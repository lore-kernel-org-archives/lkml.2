Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab2AEBuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 20:50:17 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59608 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2AEBuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 20:50:12 -0500
MIME-Version: 1.0
In-Reply-To: <1324536649-5796-1-git-send-email-ming.m.lin@intel.com>
References: <1324536649-5796-1-git-send-email-ming.m.lin@intel.com>
Date: Thu, 5 Jan 2012 09:50:11 +0800
X-Google-Sender-Auth: tWrBUzt1B2pfJkeRcXf3Y46XLbk
Message-ID: <CAF1ivSZx5pkZPQcL-X4=QA9rqvCoyW8kzg1_Q1ANsCwk-D=D=Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] fixes for ata port runtime pm support
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 2:50 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Hi Jeff,
>
> Here are the v3 fixes for ata port runtime pm support.
>
> Could you consider applying these fixes?

Hi Jeff,

Hope you have a good holiday.

How about these fixes?

Lin Ming

> Thanks.
>
> Changes in v3:
> - Add ata port hibernate callbacks
>
> Changes in v2:
> - Drop the patch "[SCSI] sd: fix runtime status check in sd_shutdown".
>  It's no longer needed with commit fe6b91f(PM / Driver core: leave
>  runtime PM enabled during system shutdown).
> - Add Ack from Alan
>
> v1: https://lkml.org/lkml/2011/12/13/443
> v2: https://lkml.org/lkml/2011/12/14/516
>
> Lin Ming (3):
>      [SCSI]: runtime resume parent for child's system-resume
>      ata: update ata port's runtime status during system resume
>      ata: add ata port hibernate callbacks
>
>  drivers/ata/libata-core.c |   58 ++++++++++++++++++++++++++++++++++++++++----
>  drivers/scsi/scsi_pm.c    |   11 +++++++-
>  2 files changed, 62 insertions(+), 7 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

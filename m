Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab1LTXGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:06:31 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43561 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1LTXG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:06:29 -0500
MIME-Version: 1.0
In-Reply-To: <1324407064-16875-1-git-send-email-kys@microsoft.com>
References: <1324407064-16875-1-git-send-email-kys@microsoft.com>
Date: Tue, 20 Dec 2011 15:06:28 -0800
X-Google-Sender-Auth: AUYN91pbCQw7KwVxNv4da54XF5g
Message-ID: <CAA9_cmf2RQapBD3th-RAhhTBB64N9ChKNFNXz0PEZJexeQUoqw@mail.gmail.com>
Subject: Re: [PATCH 1/1][RESEND] Staging: hv: storvsc: Move the storage driver
 out of the staging area
From: Dan Williams <dan.j.williams@intel.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        James.Bottomley@hansenpartnership.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 10:51 AM, K. Y. Srinivasan <kys@microsoft.com> wrote:
> The storage driver (storvsc_drv.c) handles all block storage devices
> assigned to Linux guests hosted on Hyper-V. This driver has been in the
> staging tree for a while and this patch moves it out of the staging area.
> As per Greg's recommendation, this patch makes no changes to the staging/hv
> directory. Once the driver moves out of staging, we will cleanup the
> staging/hv directory.
>
> This patch includes all the patches that I have sent against the staging/hv
> tree to address the comments I have gotten to date on this storage driver.
> Greg has already applied all these patches to the staging tree.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/Kconfig       |    7 +
>  drivers/scsi/Makefile      |    3 +
>  drivers/scsi/storvsc_drv.c | 1586 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1596 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/scsi/storvsc_drv.c

Shouldn't this diffstat be something like the following?

 drivers/scsi/Kconfig                       |    7 +
 drivers/scsi/Makefile                      |    3 +
 drivers/{staging/hv => scsi}/storvsc_drv.c |  310 +++++++++++++++++++---------
 3 files changed, 218 insertions(+), 102 deletions(-)
 rename drivers/{staging/hv => scsi}/storvsc_drv.c (87%)

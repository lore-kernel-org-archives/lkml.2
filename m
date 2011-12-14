Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab1LNK7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 05:59:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47278 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1LNK7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 05:59:04 -0500
Message-ID: <4EE8813B.1090802@mvista.com>
Date: Wed, 14 Dec 2011 14:58:03 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] [SCSI] sd: fix runtime status check in sd_shutdown
References: <1323832681-7177-1-git-send-email-ming.m.lin@intel.com> <1323832681-7177-2-git-send-email-ming.m.lin@intel.com>
In-Reply-To: <1323832681-7177-2-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 14-12-2011 7:17, Lin Ming wrote:

> Commit af8db15 disabled device's runtime PM during shutdown.

    Please also specify that commit's summary in parens.

> So sd's runtime status can't be checked with pm_runtime_suspended(dev)
> any more.

> Fix it by checking runtime status with pm_runtime_status_suspended(dev).

> Signed-off-by: Lin Ming<ming.m.lin@intel.com>

WBR, Sergei


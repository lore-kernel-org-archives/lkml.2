Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab2KWHZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:25:26 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:57255 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755867Ab2KWHZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:25:25 -0500
Message-ID: <50AF24EF.50107@marvell.com>
Date: Fri, 23 Nov 2012 15:25:35 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Qing Xu <qingx@marvell.com>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 6/7] mfd: max8925: support dt for backlight
References: <1352188034-9982-1-git-send-email-qingx@marvell.com>
In-Reply-To: <1352188034-9982-1-git-send-email-qingx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Nov 2012 07:24:12.0656 (UTC) FILETIME=[89484F00:01CDC94B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 03:47 PM, Qing Xu wrote:
> From: Qing Xu <qingx@marvell.com>
>
> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---
>   drivers/video/backlight/max8925_bl.c |   31 ++++++++++++++++++++++++++++++-
>   1 files changed, 30 insertions(+), 1 deletions(-)
>
Hi Richard, Florian,

Could you help to review this patch, thanks a lot!

-Qing

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab2KWHNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:13:05 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:36739 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932743Ab2KWHND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:13:03 -0500
Message-ID: <50AF224D.4070209@marvell.com>
Date: Fri, 23 Nov 2012 15:14:21 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Qing Xu <qingx@marvell.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 2/7] mfd: max8925: fix mfd device register failure
References: <1352187498-9754-1-git-send-email-qingx@marvell.com>
In-Reply-To: <1352187498-9754-1-git-send-email-qingx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Nov 2012 07:12:57.0515 (UTC) FILETIME=[F6DDF7B0:01CDC949]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 03:38 PM, Qing Xu wrote:
> From: Qing Xu <qingx@marvell.com>
>
> we encounter rtc/power/touch driver registry failure, root cause
> it is resources confilict in insert_resouce, solved by changing
> mfd_add_devices 5th parameter to NULL
>
> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---
>   drivers/mfd/max8925-core.c |   22 ++++++++++------------
>   1 files changed, 10 insertions(+), 12 deletions(-)
Hi Haojian, Sameo,

Could you help to review my patches? Can it be merged?

Thanks a lot!
-Qing

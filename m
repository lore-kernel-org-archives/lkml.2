Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab2KWH2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:28:24 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:37170 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932513Ab2KWH2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:28:23 -0500
Message-ID: <50AF25D8.6000004@marvell.com>
Date: Fri, 23 Nov 2012 15:29:28 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Qing Xu <qingx@marvell.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 7/7] mfd: max8925: add dts
References: <1352188180-10028-1-git-send-email-qingx@marvell.com>
In-Reply-To: <1352188180-10028-1-git-send-email-qingx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Nov 2012 07:28:05.0437 (UTC) FILETIME=[1407DED0:01CDC94C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 03:49 PM, Qing Xu wrote:
> From: Qing Xu <qingx@marvell.com>
>
> add max8925 dts support into mmp2 brownstone platform
>
> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---
>   arch/arm/boot/dts/mmp2-brownstone.dts |  166 +++++++++++++++++++++++++++++++++
>   arch/arm/boot/dts/mmp2.dtsi           |    4 +-
>   2 files changed, 169 insertions(+), 1 deletions(-)

Hi Russell, Haojian,

Could you help to review my patch, thanks a lot!

-Qing


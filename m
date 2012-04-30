Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab2D3NXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 09:23:09 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:35012 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290Ab2D3NXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 09:23:07 -0400
Message-ID: <4F9E9229.4020904@marvell.com>
Date: Mon, 30 Apr 2012 21:22:49 +0800
From: Yilu Mao <ylmao@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Lu Mao <ylmao@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ning Jiang <njiang1@marvell.com>
Subject: Re: [PATCH] ARM: cache-l2x0.c: save aux ctrl for resume in case that
 l2x0 is enabled before init
References: <4F99148B.4020900@marvell.com> <20120426094400.GD18136@arm.com> <4F991ED6.8060109@marvell.com> <20120426102815.GE18136@arm.com> <4F9924FB.7070308@marvell.com> <20120426103840.GA6294@arm.com> <4F9927F2.5060408@marvell.com> <20120426105651.GB6294@arm.com> <4F992B80.6040207@marvell.com> <4F9B8D1C.6090400@marvell.com> <20120430121125.GN10632@arm.com>
In-Reply-To: <20120430121125.GN10632@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 08:11 PM, Catalin Marinas wrote:
> On Sat, Apr 28, 2012 at 07:24:28AM +0100, Yilu Mao wrote:
>> Do you agree with this patch to be merged?
>
> I would rather re-read the aux_ctrl register again after it was set (if
> L2 is disabled) and store this value. It makes sense if some of the bits
> are reserved, at least we have the real value.
>
Ok, I have provided a V4 patch including this.
Please help to review.

-- 
Thanks.

Best Wishes,
Yilu Mao

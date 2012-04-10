Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab2DJRzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 13:55:47 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:9503 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab2DJRzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 13:55:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-131.messagelabs.com!1334080533!9124346!10
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: Rafal Prylowski <prylowski@metasoft.pl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Date: Tue, 10 Apr 2012 12:55:36 -0500
Subject: RE: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Topic: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Index: Ac0XP4rI2t+QVQG8SjqgOoZl3N6nYgAAzgdw
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206986C01D4@AUSP01VMBX24.collaborationhost.net>
References: <4F683B36.8090101@metasoft.pl>
 <20120321193836.GC3740@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48E3E@AUSP01VMBX24.collaborationhost.net>
 <20120323070446.GC5812@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48EEB@AUSP01VMBX24.collaborationhost.net>
 <20120410172853.GA25697@mwesterb-mobl>
In-Reply-To: <20120410172853.GA25697@mwesterb-mobl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 10, 2012 10:29 AM, Mika Westerberg wrote:
> On Fri, Mar 23, 2012 at 11:09:50AM -0500, H Hartley Sweeten wrote:
>> On Friday, March 23, 2012 12:05 AM, Mika Westerberg wrote:
>>> On Thu, Mar 22, 2012 at 09:19:10PM -0500, H Hartley Sweeten wrote:
>>>
>>>> Did you test this patch or just review it?
>>>
>>> I tested and reviewed it.
>> 
>> OK. What kernel? My tests so far have been with 3.3.
>> 
>>>> On my system it doesn't work. I think it has something to do with the
>>>> changes to m2m_hw_interrupt but I haven't tracked it down yet.
>>>> 
>>>> It looks like what's missing is a:
>>>> 
>>>> 	edmac->edma->hw_submit(edmac);
>>>> 
>>>> But, maybe that's not needed with double buffering?
>>>
>>> Did you try without your patch and adding my VIC hack? That's what I did when
>>> I first got this patch and I saw no problems. I tested with audio (M2P),
>>> mmc_spi (M2M) and dmatest (M2M).
>> 
>> No, I have not applied your VIC hack.
>> 
>> Until we get a working solution, without any hacks, I don't want this to go in.
>
> Now that the spurious interrupts thing with VIC has been sorted out, should we
> revisit this patch? Hartley, do you have any objections merging this?

I have not had a chance to look at this with the VIC issue fixed.

Last time I tried testing the double buffering patch my system would not boot
correctly. I'll try to test this again shortly.

Rafal,

Could you repost the latest version of the patch?

Regards,
Hartley

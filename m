Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab1EZSmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:42:51 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:63599 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab1EZSmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:42:50 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-132.messagelabs.com!1306435320!26993634!19
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.72]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>,
        "Koul, Vinod" <vinod.koul@intel.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Date: Thu, 26 May 2011 13:42:38 -0500
Subject: RE: [PATCH 1/5] dmaengine: add ep93xx DMA support
Thread-Topic: [PATCH 1/5] dmaengine: add ep93xx DMA support
Thread-Index: Acwb0SwnGhFbclU4SPapCEdUdc10pgAA2T+A
Message-ID: <0D753D10438DA54287A00B027084269764D3319E9D@AUSP01VMBX24.collaborationhost.net>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
 <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
 <1306310403.30236.94.camel@vkoul-udesk3> <20110525190055.GB2996@acer>
 <1306384690.30236.202.camel@vkoul-udesk3> <20110526181524.GD2957@acer>
In-Reply-To: <20110526181524.GD2957@acer>
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

On Thursday, May 26, 2011 11:15 AM, Mika Westerberg wrote:
> On Thu, May 26, 2011 at 10:08:10AM +0530, Koul, Vinod wrote:
>> On Thu, 2011-05-26 at 00:30 +0530, Mika Westerberg wrote:
>>> On Wed, May 25, 2011 at 01:30:03PM +0530, Koul, Vinod wrote:
>>>> 
>>>> Which tree are these patches going thru?
>>> 
>>> I was hoping that the dmaengine driver itself would go via dmaengine tree (is
>>> it you or Dan who maintain it?) and rest of the patches probably through their
>>> respective trees. However, since there are dependencies between the patches,
>>> I'm not entirely sure how to proceed with these. Any ideas appreciated :)
>> Okay, I can take the DMA one only. 
>> It stoo late for .40, I can take it for .41 or whatever that turns out to be 
>
> Great, thanks.
>
> I'll send updated version of the patches soon where I have gathered all the acks
> and updated Ryan's email address.

Mika,

I'll try to test the patches on my setup today.

Regards,
Hartley
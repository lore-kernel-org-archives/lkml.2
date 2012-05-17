Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab2EQVNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 17:13:01 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:39394 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab2EQVM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 17:12:59 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-132.messagelabs.com!1337289175!11928894!4
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Ian Abbott <ian.abbott@mev.co.uk>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
Date: Thu, 17 May 2012 16:12:54 -0500
Subject: RE: [PATCH] staging: comedi: Convert struct addi_board
 initialization to C99 format
Thread-Topic: [PATCH] staging: comedi: Convert struct addi_board
 initialization to C99 format
Thread-Index: Ac00WuXOsS3Meow8QcuuUAZiFLnAKAAFe5jQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698AE1119@AUSP01VMBX24.collaborationhost.net>
References: <201205161751.56913.hartleys@visionengravers.com>
 <20120517021805.GA32592@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F00206986FBDDF@AUSP01VMBX24.collaborationhost.net>
 <4FB49E74.8030409@mev.co.uk> <20120517133221.GB5090@kroah.com>
 <4FB51FFA.3090800@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F0020698AE0FF8@AUSP01VMBX24.collaborationhost.net>
 <4FB54356.5020203@mev.co.uk>
In-Reply-To: <4FB54356.5020203@mev.co.uk>
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

On Thursday, May 17, 2012 11:29 AM, Ian Abbott wrote:
> On 17/05/2012 17:38, H Hartley Sweeten wrote:
>> BTW, what actual hardware do you have available to test with?
>
> Not a lot.  Just the Amplicon cards (amplc_* drivers).

Speaking of the amplc_* drivers... What's up with them?

The dio200, pc236, and pc263 drivers appear to be some kind of
hybrid comedi driver/comedi pci driver. If the driver is simply
registered as a comedi pci driver will the isa drivers still work?
If so we can get rid of a bunch of #ifdef stuff.

Regards,
Hartley

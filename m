Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab1GNUK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 16:10:57 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:26097 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab1GNUK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 16:10:56 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1310674227!31942354!10
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.178]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "wim@iguana.be" <wim@iguana.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tim.bird@am.sony.com" <tim.bird@am.sony.com>
Date: Thu, 14 Jul 2011 15:10:37 -0500
Subject: RE: [RFC 0/6] watchdog drivers converted to the new framework
Thread-Topic: [RFC 0/6] watchdog drivers converted to the new framework
Thread-Index: AcxCYMaMO/hOesJQTDy7loI6OMCIpAAACILg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F383E05C4A@AUSP01VMBX24.collaborationhost.net>
References: <1310588766-16638-1-git-send-email-w.sang@pengutronix.de>
 <ADE657CA350FB648AAC2C43247A983F001F383E05B65@AUSP01VMBX24.collaborationhost.net>
 <20110714182734.GA31082@pengutronix.de>
 <ADE657CA350FB648AAC2C43247A983F001F383E05BCD@AUSP01VMBX24.collaborationhost.net>
 <20110714200053.GC31082@pengutronix.de>
In-Reply-To: <20110714200053.GC31082@pengutronix.de>
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

On Thursday, July 14, 2011 1:01 PM, Wolfram Sang wrote:
> On Thu, Jul 14, 2011 at 01:42:02PM -0500, H Hartley Sweeten wrote:
>> On Thursday, July 14, 2011 11:28 AM, Wolfram Sang wrote:
>>>> I would also like to convert this driver into a proper platform_driver using
>>>> ioremap'ed addresses instead of the static mappings.  Converting the driver
>>>> to the new watchdog framework would make this a bit cleaner.
>>>
>>> Try managed devices (devm_* and friends) for an extra cleanup bonus.
>> 
>> Already done, just waiting for the framework... ;-)
>
> Nice :) Did you use my conversion-guide as a reference? Any comments if so?

Sorry, I didn't.  I just worked it out from the framework core and looking
at your examples.

When I found the framework patches on lkml I couldn't get them into a state
to apply to my tree.  I ended up manually applying all the pieces so I skipped
the Documentation stuff to save some time.

The conversion is pretty straight forward after examining the watchdog
framework files.

Regards,
Hartley
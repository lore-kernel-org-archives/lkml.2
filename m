Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201Ab2DYMEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:04:50 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:56191 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847Ab2DYMEr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:04:47 -0400
MIME-Version: 1.0
In-Reply-To: <4F97E243.1040707@antcom.de>
References: <1335346004-18108-1-git-send-email-sourav.poddar@ti.com>
	<20120425105235.GV24211@n2100.arm.linux.org.uk>
	<4F97E243.1040707@antcom.de>
Date: Wed, 25 Apr 2012 17:26:28 +0530
Message-ID: <CAKdam57H-JH_vgohMo6Mp3jF46irBJJphj-bHc8SBZUXv564Ug@mail.gmail.com>
Subject: Re: [PATCHv4 1/2] drivers: input: keypad: Add device tree support
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: Roland Stigge <stigge@antcom.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@xenotime.net>, Felipe Balbi <balbi@ti.com>,
        linux-input@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

On Wed, Apr 25, 2012 at 5:08 PM, Roland Stigge <stigge@antcom.de> wrote:
> Hi Russell and Sourav,
>
> On 04/25/2012 12:52 PM, Russell King - ARM Linux wrote:
>> I think you and Roland Stigge need to put your heads together and come
>> up with a common DT binding for matrix keypad devices, rather than
>> inventing N different platform specific bindings.
>>
>>> +Required Board Specific Properties, in addition to those specified by
>>> +the shared matrix-keyboard bindings:
>>> +- keypad,num-rows: Number of row lines connected to the keypad
>>> +  controller.
>>> +
>>> +- keypad,num-columns: Number of column lines connected to the
>>> +  keypad controller.
>
> Right - the LPC32xx key scanner always has a square matrix design (#rows
> == #cols), but I'm fine with re-using properties "keypad,num-rows" and
> "keypad,num-columns" instead of "nxp,matrix-size".
>
> Besides, I still have "nxp,debounce-delay-ms" and "nxp,scan-delay-ms" -
> do I need to change this to some default properties I don't know of (yet)?
>
I think these are the custom properties which should be kept in your bindings.
I dont see anything of these sort in
Documentation/devicetree/bindings/input/matrix-keymap.txt .
> And: I re-used the DT subnodes strategy for the keycodes ("linux,code")
> of the samsung-keypad driver, see
> Documentation/devicetree/bindings/input/samsung-keypad.txt - can I
> continue using it?

Even I was using the bindings as used by samsung-keypad driver. But according
to the comments and logically too, we should use the common matrix keyboard
bindings already descibed in
Documentation/devicetree/bindings/input/matrix-keymap.txt.
So that we can get rid of multiple bindings for different platform.

~Sourav
> Thanks in advance,
>
> Roland

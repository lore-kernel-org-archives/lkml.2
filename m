Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab2DYNAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:00:43 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:44800 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754680Ab2DYNAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:00:42 -0400
MIME-Version: 1.0
In-Reply-To: <4F97EACA.9070603@antcom.de>
References: <1335346004-18108-1-git-send-email-sourav.poddar@ti.com>
	<20120425105235.GV24211@n2100.arm.linux.org.uk>
	<4F97E243.1040707@antcom.de>
	<CAKdam57H-JH_vgohMo6Mp3jF46irBJJphj-bHc8SBZUXv564Ug@mail.gmail.com>
	<4F97EACA.9070603@antcom.de>
Date: Wed, 25 Apr 2012 18:30:39 +0530
Message-ID: <CAKdam56PrS_UT-owMq9xAQkoYxQHeenErT-vwJazqoNuECCbBw@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

On Wed, Apr 25, 2012 at 5:45 PM, Roland Stigge <stigge@antcom.de> wrote:
> Hi!
>
> On 04/25/2012 01:56 PM, Poddar, Sourav wrote:
>> Even I was using the bindings as used by samsung-keypad driver. But according
>> to the comments and logically too, we should use the common matrix keyboard
>> bindings already descibed in
>> Documentation/devicetree/bindings/input/matrix-keymap.txt.
>
> Fine with me. Can switch over to
> Documentation/devicetree/bindings/input/matrix-keymap.txt
>
> Maybe samsung-keypad should also be converted because it's subnodes
> structure duplicates exactly the same thing (row,col,code) in a
> different way, and we both were distracted by it, ignoring
> matrix-keymap.txt? Or is it already too late (both samsung-keypad and

Not sure about the standards, but surely have seen few others like tegra
keyboards using common matrix-keyboard bindings.

One more comment which I saw in some other mail thread about
using the following
              key_1 {
                        keypad,row = <0>;
                        keypad,column = <3>;
                        linux,code = <2>;
                };
is that when there are too many keys, the whole data become quilte huge.
These problem get sorted out on using matrix-keymap bindings, since there
is a single value computed in order to describe a particular key.

~Sourav

> matrix-keypad both being standards in use) and we should put a
> recommendation into one of them to use the other one for new designs?
>

> Thanks,
>
> Roland
>

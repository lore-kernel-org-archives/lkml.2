Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145Ab2DYMPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:15:11 -0400
Received: from antcom.de ([188.40.178.216]:45301 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758175Ab2DYMPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:15:09 -0400
Message-ID: <4F97EACA.9070603@antcom.de>
Date: Wed, 25 Apr 2012 14:15:06 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: "Poddar, Sourav" <sourav.poddar@ti.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@xenotime.net>, Felipe Balbi <balbi@ti.com>,
        linux-input@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv4 1/2] drivers: input: keypad: Add device tree support
References: <1335346004-18108-1-git-send-email-sourav.poddar@ti.com> <20120425105235.GV24211@n2100.arm.linux.org.uk> <4F97E243.1040707@antcom.de> <CAKdam57H-JH_vgohMo6Mp3jF46irBJJphj-bHc8SBZUXv564Ug@mail.gmail.com>
In-Reply-To: <CAKdam57H-JH_vgohMo6Mp3jF46irBJJphj-bHc8SBZUXv564Ug@mail.gmail.com>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 04/25/2012 01:56 PM, Poddar, Sourav wrote:
> Even I was using the bindings as used by samsung-keypad driver. But according
> to the comments and logically too, we should use the common matrix keyboard
> bindings already descibed in
> Documentation/devicetree/bindings/input/matrix-keymap.txt.

Fine with me. Can switch over to
Documentation/devicetree/bindings/input/matrix-keymap.txt

Maybe samsung-keypad should also be converted because it's subnodes
structure duplicates exactly the same thing (row,col,code) in a
different way, and we both were distracted by it, ignoring
matrix-keymap.txt? Or is it already too late (both samsung-keypad and
matrix-keypad both being standards in use) and we should put a
recommendation into one of them to use the other one for new designs?

Thanks,

Roland


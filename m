Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab2DZOjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:39:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45576 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab2DZOjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:39:41 -0400
Message-ID: <4F995E28.1050203@wwwdotorg.org>
Date: Thu, 26 Apr 2012 08:39:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: "Poddar, Sourav" <sourav.poddar@ti.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCHv4 1/2] drivers: input: keypad: Add device tree support
References: <1335346004-18108-1-git-send-email-sourav.poddar@ti.com>	<4F981CD1.2050007@wwwdotorg.org> <CAKdam56ONhS_drgfHCeY6aKWp3nT0PtDEO5SMCKxG+dGVPS66A@mail.gmail.com>
In-Reply-To: <CAKdam56ONhS_drgfHCeY6aKWp3nT0PtDEO5SMCKxG+dGVPS66A@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 12:33 AM, Poddar, Sourav wrote:
> On Wed, Apr 25, 2012 at 9:18 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
...
>> It's probably worth considering whether num-rows/columns should be part
>> of matrix-keyboard.txt, and whether linux,keypad-no-autorepeat should be
>> part of some core keyboard binding. Some of the properties in
>> tegra-kbc.txt might be worth generalizing too (debounce/repeat delay,
>> ghost filter)?
>
> Yes, I also think that its a good idea to make some of the above
> binding more generic. Though, I think "linux,keypad-no-autorepeat"
> will still be a custom binding, since its totally on the platform
> whether to use
> autorepeat feature or not?

I think the concept of whether autorepeat should be enabled is pretty
generic. The actual value of the property might well be
board/platform-specific, so may differ in individual board .dts files.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab2DWPkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:40:49 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:55825 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784Ab2DWPks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:40:48 -0400
MIME-Version: 1.0
In-Reply-To: <4F95749E.40708@wwwdotorg.org>
References: <1335194839-30193-1-git-send-email-sourav.poddar@ti.com>
	<4F95749E.40708@wwwdotorg.org>
Date: Mon, 23 Apr 2012 21:10:45 +0530
Message-ID: <CAKdam541af1bU8_64gTZva9VS0R3dTR=3L3J50o9HgHH+WaPYQ@mail.gmail.com>
Subject: Re: [PATCHv3 1/2] drivers: input: keypad: Add device tree support
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Apr 23, 2012 at 8:56 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/23/2012 09:27 AM, Sourav Poddar wrote:
>> Update the Documentation with omap4 keypad device tree
>> binding information.
>> Add device tree support for omap4 keypad driver.
>
> Shouldn't this use the already-defined matrix keyboard bindings at
> Documentation/devicetree/bindings/input/matrix-keymap.txt?
>
True, that is one way of describing the linux-keymap, but i think it can be
done  either ways.

Are you hinting at getting rid of Documentation for each seperate modules and
just use a single  Documentation/devicetree/bindings/input/matrix-keymap.txt?


> (I asked this before, but don't recall seeing any response explaining
> why a new binding was needed. Sorry if I missed it.)
Sorry, It was  I  who missed it.

~Sourav

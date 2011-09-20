Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1ITVUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:20:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55576 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1ITVUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:20:07 -0400
MIME-Version: 1.0
In-Reply-To: <yunpqivfbtf.fsf@aiko.keithp.com>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<1316107275.23214.99.camel@deskari>
	<yunfwjxwbjq.fsf@aiko.keithp.com>
	<20110916175326.54567b14@lxorguk.ukuu.org.uk>
	<1316414014.1978.12.camel@deskari>
	<yunfwjtauqg.fsf@aiko.keithp.com>
	<1316417361.1978.48.camel@deskari>
	<CAMeQTsbP-_ut7BA3YQ+qgtqfM1tzM4qn3jxHT8B8_0hdPbP3Jg@mail.gmail.com>
	<yunpqivfbtf.fsf@aiko.keithp.com>
Date: Tue, 20 Sep 2011 23:20:05 +0200
Message-ID: <CAMeQTsazfb6xoA6mm8OMVhkx_RDaxogqEa8yDstqmKUP5Ub+yg@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-dev@lists.linaro.org, "Clark, Rob" <rob@ti.com>,
        Archit Taneja <archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 5:55 PM, Keith Packard wrote:
> I'm not sure we need a new abstraction that subsumes both DSI and SDVO,

Ok. SDVO fits within the current abstraction, but I guess what I'm fishing
for is more code sharing of encoders. For instance, the SDVO code in GMA500
could be shared with i915. I'm currently working on copying the i915 SDVO code
over to GMA500, but sharing it would be even better.

> but we may need a DSI library that can be used by both DRM and other
> parts of the kernel.

Ok, not sure I understand the complexity of DSI. Can overlay composition
occur after/at the DSI stage (through MCS perhaps)? Or is it a matter of
panels requiring special scanout buffer formats that for instance V4L needs
to know about in order to overlay stuff properly? Or am I getting it all wrong?

Thanks
-Patrik

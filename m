Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab1IUGBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 02:01:24 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:45252 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583Ab1IUGBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 02:01:23 -0400
Subject: Re: Proposal for a low-level Linux display framework
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-dev@lists.linaro.org,
        "Clark, Rob" <rob@ti.com>, Archit Taneja <archit@ti.com>
In-Reply-To: <CAMeQTsazfb6xoA6mm8OMVhkx_RDaxogqEa8yDstqmKUP5Ub+yg@mail.gmail.com>
References: <1316088425.11294.78.camel@lappyti>
	 <yunboul7sx7.fsf@aiko.keithp.com> <1316100594.23214.65.camel@deskari>
	 <yun8vpp7qk7.fsf@aiko.keithp.com> <1316107275.23214.99.camel@deskari>
	 <yunfwjxwbjq.fsf@aiko.keithp.com>
	 <20110916175326.54567b14@lxorguk.ukuu.org.uk>
	 <1316414014.1978.12.camel@deskari> <yunfwjtauqg.fsf@aiko.keithp.com>
	 <1316417361.1978.48.camel@deskari>
	 <CAMeQTsbP-_ut7BA3YQ+qgtqfM1tzM4qn3jxHT8B8_0hdPbP3Jg@mail.gmail.com>
	 <yunpqivfbtf.fsf@aiko.keithp.com>
	 <CAMeQTsazfb6xoA6mm8OMVhkx_RDaxogqEa8yDstqmKUP5Ub+yg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 09:01:15 +0300
Message-ID: <1316584875.1949.4.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 23:20 +0200, Patrik Jakobsson wrote:

> Ok, not sure I understand the complexity of DSI. Can overlay composition
> occur after/at the DSI stage (through MCS perhaps)? Or is it a matter of
> panels requiring special scanout buffer formats that for instance V4L needs
> to know about in order to overlay stuff properly? Or am I getting it all wrong?

I don't know what MCS is. But DSI is just a bi-directional transfer
protocol between the SoC and the peripheral, you can send arbitrary data
over it.

Normally the SoC composes a pixel stream using overlays and whatnot,
which goes to the DSI hardware, which then serializes the data and sends
it to the peripheral.

But you can as well send any data, like commands, and the peripheral can
respond with any relevant data.

 Tomi



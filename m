Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab1IQQLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 12:11:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:39358 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753212Ab1IQQLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 12:11:52 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX188gNp23Rk88Kld9K8U9Dj1v/U3eyZtw1cjk0W7RJ
	1oJ9DK+p17e1/q
Message-ID: <4E74C6C3.2000704@gmx.de>
Date: Sat, 17 Sep 2011 16:11:47 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Rob Clark <rob@ti.com>
CC: Felipe Contreras <felipe.contreras@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Archit Taneja <archit@ti.com>, linux-fbdev@vger.kernel.org
Subject: Re: Proposal for a low-level Linux display framework
References: <1316088425.11294.78.camel@lappyti>	<yunboul7sx7.fsf@aiko.keithp.com>	<1316100594.23214.65.camel@deskari>	<yun8vpp7qk7.fsf@aiko.keithp.com>	<4E72320B.6020000@gmx.de>	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>	<4E724659.5080709@gmx.de>	<20110915195804.4e6d965b@lxorguk.ukuu.org.uk>	<CAMP44s1ywhCV+FaudnwjwJUvj5Cf3_oz1M++kjXxRDGQpJ6-0w@mail.gmail.com> <CAF6AEGu2-O+2KuCrQPJ6-xejg8TCScrFVZSimgkAV_5Xs-bgkg@mail.gmail.com>
In-Reply-To: <CAF6AEGu2-O+2KuCrQPJ6-xejg8TCScrFVZSimgkAV_5Xs-bgkg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2011 03:16 PM, Rob Clark wrote:
>>From userspace perspective, fbdev doesn't go away.  It is just a
> legacy interface provided on top of DRM/KMS driver mostly via helper
> functions.  With this approach, you get the richer KMS API (and all
> the related plumbing for hotplug, EDID parsing, multi-head support,
> flipping, etc) for userspace stuff that needs that, but can keep the
> fbdev userspace interface for legacy apps.  It is the best of both
> worlds.  There isn't really any good reason to propagate standalone
> fbdev driver anymore.

I disagree. This depends on the functionality the hardware has, the desired
userspace and the manpower one has to do it. And of course if you just want fb
having fb via DRM/KMS has some overhead/bloat. It's perfectly okay to have just
an fb driver for devices that can't do more anyway.
And fb is no legacy interface but actively developed, just with other goals than
DRM/KMS is, it aims for stability and to provide a direct interface, not needing
any X or wayland crap.


Best regards,

Florian Tobias Schandinat

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab1IORMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:12:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55580 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751628Ab1IORMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:12:52 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/cItROEBfc6kdMqlkakdPGpDZQOok6arA6KF3Uzq
	xy3NZA1AQHD0Ak
Message-ID: <4E72320B.6020000@gmx.de>
Date: Thu, 15 Sep 2011 17:12:43 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-dev@lists.linaro.org, "Clark\, Rob" <rob@ti.com>,
        Archit Taneja <archit@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
References: <1316088425.11294.78.camel@lappyti> <yunboul7sx7.fsf@aiko.keithp.com> <1316100594.23214.65.camel@deskari> <yun8vpp7qk7.fsf@aiko.keithp.com>
In-Reply-To: <yun8vpp7qk7.fsf@aiko.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2011 03:50 PM, Keith Packard wrote:
> On Thu, 15 Sep 2011 18:29:54 +0300, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> 
>> 1) It's part of DRM, so it doesn't help fb or v4l2 drivers. Except if
>> the plan is to make DRM the core Linux display framework, upon which
>> everything else is built, and fb and v4l2 are changed to use DRM.
> 
> I'd like to think we could make DRM the underlying display framework;
> it already exposes an fb interface, and with overlays, a bit more of the
> v4l2 stuff is done as well. Certainly eliminating three copies of mode
> setting infrastructure would be nice...

Interesting that this comes from the people that pushed the latest mode setting
code into the kernel. But I don't think that this will happen, the exposed user
interfaces will be around for decades and the infrastructure code could be
shared, in theory.
For fb and V4L2 I think we'll develop some level of interoperability, share
concepts and maybe even some code. The FOURCC pixel formats and overlays are
such examples. As Laurent is really interested in it I think we can get some
nice progress here.
For fb and DRM the situation is entirely different. The last proposal I remember
ended in the DRM people stating that only their implementation is acceptable as
is and we could use it. Such attitude is not helpful and as I don't see any
serious intention of the DRM guys to cooperate I think those subsystems are more
likely to diverge. At least I'll never accept any change to the fb
infrastructure that requires DRM.


Regards,

Florian Tobias Schandinat

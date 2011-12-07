Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab1LGX4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 18:56:00 -0500
Received: from ffm.saftware.de ([83.141.3.46]:44290 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab1LGXz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 18:55:59 -0500
Message-ID: <4EDFFD0A.2040800@linuxtv.org>
Date: Thu, 08 Dec 2011 00:55:54 +0100
From: Andreas Oberritter <obi@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Patrick Dickey <pdickeybeta@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, HoP <jpetrous@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com> <4EDD2C82.7040804@linuxtv.org> <20111206112153.GC17194@sirena.org.uk> <4EDE0427.2050307@linuxtv.org> <20111206141929.GE17731@opensource.wolfsonmicro.com> <4EDE2B3B.2080905@linuxtv.org> <20111207134848.GB18837@opensource.wolfsonmicro.com> <4EDF71AE.5070509@linuxtv.org> <4EDFDF3F.8020202@gmail.com>
In-Reply-To: <4EDFDF3F.8020202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.12.2011 22:48, Patrick Dickey wrote:
> 4 (and the reason I decided to chime in here).  This email sums
> everything up. Mark is pointing out that someone may want to use this in
> a non LAN setting, and they may/will have problems due to the Internet
> (and their specific way of accessing it). Andreas is arguing that it's
> not the case.

I'm sorry if I was unclear, but I'm not doing that. Contrary, I'm sure
that people using dreamtuner (which uses vtunerc from userspace) over
the Internet will run into problems if they can't provide the necessary
bandwidth.

What I'm trying to point out is that dreamtuner is not trying to solve
these problems, because it specifically has been designed for a
different purpose.

> I have to side with Mark on this one, solely because if I knew that it
> would work, I'd use it to watch television when I'm traveling (as some
> places don't carry the same channels that I have at home).

Yes, if you knew. But you wouldn't, because when travelling, it's
unlikely that you could guarantee the necessary bandwidth all the time.
I'd highly recommend you and Mark to use a different solution than
dreamtuner for your use cases.

> So, I would
> prove Mark's point.

I wonder how.

> Andreas, you said that "virtually EVERY (emphasis mine) user of it will
> use it on a LAN". "Virtually" implies almost all-- NOT ALL. So, unless
> there's some restriction in the application, which prevents it from
> being used over the Internet, you can't guarantee that Mark's issues
> aren't valid.

It may or may not work for some people. There's no need to artificially
restrict dreamtuner to hosts on a LAN (which would be impossible anyway).

> If as HoP pointed out in another reply on this thread, there's no kernel
> patching required, then I suggest that you keep on developing it as a
> userspace application. There's no law/rule/anything that says you can't
> install your own driver in the kernel. It just won't be supported
> upstream.  That just means more work for you, if you want the
> application to continue working in the future. Truthfully, that has it's
> upsides also. If you find out about a way to improve the transmission,
> you don't have to wait (and hope) that it gets included in the kernel.
> You can include it in your driver.

FWIW, It's HoP's code. I'm not developing it.

Although you seem to have noticed that all networking happens in
userspace, you're still discussing networking issues, which may or may
not be issues of dreamtuner, but provably not of vtunerc, which just
relays DVB driver calls to userspace.

Since the topic is about the inclusion of vtunerc, not dreamtuner, such
stuff really is totally off-topic, but unfortunately got brought up
again and again.

You don't drive a formula one car or a truck if you want to have a
picnic with your family, do you? I guess you'd rather choose the right
tool for this task. So should you do if you want to stream television
over the net. People complaining that they can't transport their family
in a formula one car don't help anybody. Still both formula one cars and
trucks may be useful for other purposes.

You're free to replace dreamtuner with your superior tool solving all of
Mark's issues, even without the need to change vtunerc.

So far many people jumped into this discussion, but virtually(!) nobody
took the time to understand what vtunerc actually does by looking at the
code or at the various links HoP provided.

Regards,
Andreas

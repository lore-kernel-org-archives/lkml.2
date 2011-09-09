Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934000Ab1IIV1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 17:27:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:57872 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345Ab1IIV1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 17:27:38 -0400
Date: Fri, 9 Sep 2011 23:27:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steve Grubb <sgrubb@redhat.com>
cc: Sandy Harris <sandyinchina@gmail.com>, Neil Horman <nhorman@redhat.com>,
        Tomas Mraz <tmraz@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, Jarod Wilson <jarod@redhat.com>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
In-Reply-To: <201109090904.18321.sgrubb@redhat.com>
Message-ID: <alpine.LFD.2.02.1109092241390.2723@ionos>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <201109080911.12921.sgrubb@redhat.com> <CACXcFmnnMLHq2VE35i4QK4wNePXHJc6T73VQNTmJo7WEz34DaQ@mail.gmail.com> <201109090904.18321.sgrubb@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Sep 2011, Steve Grubb wrote:
> But what I was trying to say is that we can't depend on these supplemental hardware 
> devices like TPM because we don't have access to the proprietary technical details 
> that would be necessary to supplement the analysis. And when it comes to TPM chips, I 
> bet each chip has different details and entropy sources and entropy estimations and 
> rates. Those details we can't get at, so we can't solve the problem by including that 
> hardware. That is the point I was trying to make. :)

Well, there is enough prove out there that the hardware you're using
is a perfect random number generator by itself.

So stop complaining about not having access to TPM chips if you can
create an entropy source just by (ab)using the inherent randomness of
modern CPU architectures to refill your entropy pool on the fly when
the need arises w/o imposing completely unintuitive thresholds and
user visible API changes.

Thanks,

	tglx



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab1ILOBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:01:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab1ILOBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:01:01 -0400
Message-ID: <4E6E0F90.4090905@redhat.com>
Date: Mon, 12 Sep 2011 09:56:32 -0400
From: Jarod Wilson <jarod@redhat.com>
User-Agent: Postbox 2.5.2 (Macintosh/20110804)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Steve Grubb <sgrubb@redhat.com>, Sandy Harris <sandyinchina@gmail.com>,
        Neil Horman <nhorman@redhat.com>, Tomas Mraz <tmraz@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <201109080911.12921.sgrubb@redhat.com> <CACXcFmnnMLHq2VE35i4QK4wNePXHJc6T73VQNTmJo7WEz34DaQ@mail.gmail.com> <201109090904.18321.sgrubb@redhat.com> <alpine.LFD.2.02.1109092241390.2723@ionos>
In-Reply-To: <alpine.LFD.2.02.1109092241390.2723@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 9 Sep 2011, Steve Grubb wrote:
>> But what I was trying to say is that we can't depend on these supplemental hardware
>> devices like TPM because we don't have access to the proprietary technical details
>> that would be necessary to supplement the analysis. And when it comes to TPM chips, I
>> bet each chip has different details and entropy sources and entropy estimations and
>> rates. Those details we can't get at, so we can't solve the problem by including that
>> hardware. That is the point I was trying to make. :)
>
> Well, there is enough prove out there that the hardware you're using
> is a perfect random number generator by itself.
>
> So stop complaining about not having access to TPM chips if you can
> create an entropy source just by (ab)using the inherent randomness of
> modern CPU architectures to refill your entropy pool on the fly when
> the need arises w/o imposing completely unintuitive thresholds and
> user visible API changes.

We started out going down that path:

http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg05778.html

We hit a bit of a roadblock with it though.

-- 
Jarod Wilson
jarod@redhat.com



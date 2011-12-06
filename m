Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444Ab1LFMBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 07:01:47 -0500
Received: from ffm.saftware.de ([83.141.3.46]:50954 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933269Ab1LFMBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 07:01:46 -0500
Message-ID: <4EDE0427.2050307@linuxtv.org>
Date: Tue, 06 Dec 2011 13:01:43 +0100
From: Andreas Oberritter <obi@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, HoP <jpetrous@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com> <4EDD2C82.7040804@linuxtv.org> <20111206112153.GC17194@sirena.org.uk>
In-Reply-To: <20111206112153.GC17194@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.12.2011 12:21, Mark Brown wrote:
> On Mon, Dec 05, 2011 at 09:41:38PM +0100, Andreas Oberritter wrote:
>> On 05.12.2011 18:39, Mauro Carvalho Chehab wrote:
> 
>>> When you put someone via the network, issues like latency,  package
>>> drops, IP
>>> congestion, QoS issues, cryptography, tunneling, etc should be taken
>>> into account
>>> by the application, in order to properly address the network issues.
> 
>> Are you serious? Lower networking layers should be transparent to the
>> upper layers. You don't implement VPN or say TCP in all of your
>> applications, do you? These are just some more made-up arguments which
>> don't have anything to do with the use cases I explained earlier.
> 
> For real time applications it does make a big difference - decisions
> taken at the application level can greatly impact end application
> performance.  For example with VoIP on a LAN you can get great audio
> quality by using very little compression at the expense of high
> bandwidth and you can probably use a very small jitter buffer.  Try
> doing that over a longer distance or more congested network which drops
> packets and it becomes useful to use a more commpressed encoding for
> your data which may have better features for handling packet loss, or to
> increase your jitter buffer to cope with the less reliable transmit
> times.

Can you please explain how this relates to the topic we're discussing?

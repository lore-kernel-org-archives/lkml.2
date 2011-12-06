Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467Ab1LFOsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:48:31 -0500
Received: from ffm.saftware.de ([83.141.3.46]:46191 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933345Ab1LFOsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:48:30 -0500
Message-ID: <4EDE2B3B.2080905@linuxtv.org>
Date: Tue, 06 Dec 2011 15:48:27 +0100
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
References: <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com> <4EDD2C82.7040804@linuxtv.org> <20111206112153.GC17194@sirena.org.uk> <4EDE0427.2050307@linuxtv.org> <20111206141929.GE17731@opensource.wolfsonmicro.com>
In-Reply-To: <20111206141929.GE17731@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.12.2011 15:19, Mark Brown wrote:
> On Tue, Dec 06, 2011 at 01:01:43PM +0100, Andreas Oberritter wrote:
>> On 06.12.2011 12:21, Mark Brown wrote:
>>> On Mon, Dec 05, 2011 at 09:41:38PM +0100, Andreas Oberritter wrote:
> 
>>>> Are you serious? Lower networking layers should be transparent to the
>>>> upper layers. You don't implement VPN or say TCP in all of your
>>>> applications, do you? These are just some more made-up arguments which
>>>> don't have anything to do with the use cases I explained earlier.
> 
>>> For real time applications it does make a big difference - decisions
>>> taken at the application level can greatly impact end application
>>> performance.  For example with VoIP on a LAN you can get great audio
> 
>> Can you please explain how this relates to the topic we're discussing?
> 
> Your assertatation that applications should ignore the underlying
> transport (which seems to be a big part of what you're saying) isn't
> entirely in line with reality.

Did you notice that we're talking about a very particular application?

VoIP really is totally off-topic. The B in DVB stands for broadcast.
There's only one direction in which MPEG payload is to be sent (using
RTP for example). You can't just re-encode the data on the fly without
loss of information.

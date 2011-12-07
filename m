Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab1LGOBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:01:25 -0500
Received: from ffm.saftware.de ([83.141.3.46]:35735 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908Ab1LGOBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:01:23 -0500
Message-ID: <4EDF71AE.5070509@linuxtv.org>
Date: Wed, 07 Dec 2011 15:01:18 +0100
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
References: <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com> <4EDD2C82.7040804@linuxtv.org> <20111206112153.GC17194@sirena.org.uk> <4EDE0427.2050307@linuxtv.org> <20111206141929.GE17731@opensource.wolfsonmicro.com> <4EDE2B3B.2080905@linuxtv.org> <20111207134848.GB18837@opensource.wolfsonmicro.com>
In-Reply-To: <20111207134848.GB18837@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.12.2011 14:49, Mark Brown wrote:
> On Tue, Dec 06, 2011 at 03:48:27PM +0100, Andreas Oberritter wrote:
>> On 06.12.2011 15:19, Mark Brown wrote:
> 
>>> Your assertatation that applications should ignore the underlying
>>> transport (which seems to be a big part of what you're saying) isn't
>>> entirely in line with reality.
> 
>> Did you notice that we're talking about a very particular application?
> 
> *sigh*
> 
>> VoIP really is totally off-topic. The B in DVB stands for broadcast.
>> There's only one direction in which MPEG payload is to be sent (using
>> RTP for example). You can't just re-encode the data on the fly without
>> loss of information.
> 
> This is pretty much exactly the case for VoIP some of the time (though
> obviously bidirectional use cases are rather common there's things like
> conferencing).  I would really expect similar considerations to apply
> for video content as they certainly do in videoconferencing VoIP
> applications - if the application knows about the network it can tailor
> what it's doing to that network.  
> 
> For example, if it is using a network with a guaranteed bandwidth it can
> assume that bandwidth.  If it knows something about the structure of the
> network it may be able to arrange to work around choke points.
> Depending on the situation even something lossy may be the answer - if
> it's the difference between working at all and not working then the cost
> may be worth it.

Once and for all: We have *not* discussed a generic video streaming
application. It's only, I repeat, only about accessing a remote DVB API
tuner *as if it was local*. No data received from a satellite, cable or
terrestrial DVB network shall be modified by this application!

Virtually *every* user of it will use it in a LAN.

It can't be so hard to understand.

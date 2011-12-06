Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab1LFRTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:19:04 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51325 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1LFRTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:19:02 -0500
MIME-Version: 1.0
In-Reply-To: <20111206141929.GE17731@opensource.wolfsonmicro.com>
References: <4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com>
	<4EDC9B17.2080701@gmail.com>
	<CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com>
	<4EDD01BA.40208@redhat.com>
	<4EDD2C82.7040804@linuxtv.org>
	<20111206112153.GC17194@sirena.org.uk>
	<4EDE0427.2050307@linuxtv.org>
	<20111206141929.GE17731@opensource.wolfsonmicro.com>
Date: Tue, 6 Dec 2011 22:49:00 +0530
Message-ID: <CAHFNz9LR_WcKkbgv9DDpbQNAX65URGLuOdOLo1LULyGPC-8i7g@mail.gmail.com>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
From: Manu Abraham <abraham.manu@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andreas Oberritter <obi@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, HoP <jpetrous@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 7:49 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Dec 06, 2011 at 01:01:43PM +0100, Andreas Oberritter wrote:
>> On 06.12.2011 12:21, Mark Brown wrote:
>> > On Mon, Dec 05, 2011 at 09:41:38PM +0100, Andreas Oberritter wrote:
>
>> >> Are you serious? Lower networking layers should be transparent to the
>> >> upper layers. You don't implement VPN or say TCP in all of your
>> >> applications, do you? These are just some more made-up arguments which
>> >> don't have anything to do with the use cases I explained earlier.
>
>> > For real time applications it does make a big difference - decisions
>> > taken at the application level can greatly impact end application
>> > performance.  For example with VoIP on a LAN you can get great audio
>
>> Can you please explain how this relates to the topic we're discussing?
>
> Your assertatation that applications should ignore the underlying
> transport (which seems to be a big part of what you're saying) isn't
> entirely in line with reality.

A point to be noted:

DVB itself is a network protocol; If you have a satellite network,
most likely it is a DVB network where the whole network packets
are encapsulated within DVB (MPEG TS) packets.

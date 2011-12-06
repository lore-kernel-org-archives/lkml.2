Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab1LFLSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:18:38 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52805 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab1LFLSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:18:36 -0500
Date: Tue, 6 Dec 2011 11:18:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, HoP <jpetrous@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
Message-ID: <20111206111829.GB17194@sirena.org.uk>
References: <4ED75F53.30709@redhat.com>
 <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
 <20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
 <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com>
 <4EDC9B17.2080701@gmail.com>
 <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com>
 <4EDD01BA.40208@redhat.com>
 <4EDD2C82.7040804@linuxtv.org>
 <20111205205554.2caeb496@lxorguk.ukuu.org.uk>
 <4EDD3583.30405@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDD3583.30405@linuxtv.org>
X-Cookie: Garbage In, Gospel Out
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 10:20:03PM +0100, Andreas Oberritter wrote:
> On 05.12.2011 21:55, Alan Cox wrote:
> > The USB case is quite different because your latency is very tightly
> > bounded, your dead device state is rigidly defined, and your loss of
> > device is accurately and immediately signalled.

> > Quite different.

> How can usbip work if networking and usb are so different and what's so
> different between vtunerc and usbip, that made it possible to put usbip
> into drivers/staging?

USB-IP is a hack that will only work well on a tightly bounded set of
networks - if you run it over a lightly loaded local network it can
work adequately.  This starts to break down as you vary the network
configuration.

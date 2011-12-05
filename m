Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab1LEVUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:20:11 -0500
Received: from ffm.saftware.de ([83.141.3.46]:53305 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226Ab1LEVUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:20:09 -0500
Message-ID: <4EDD3583.30405@linuxtv.org>
Date: Mon, 05 Dec 2011 22:20:03 +0100
From: Andreas Oberritter <obi@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, HoP <jpetrous@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com> <4EDD2C82.7040804@linuxtv.org> <20111205205554.2caeb496@lxorguk.ukuu.org.uk>
In-Reply-To: <20111205205554.2caeb496@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.12.2011 21:55, Alan Cox wrote:
> The USB case is quite different because your latency is very tightly
> bounded, your dead device state is rigidly defined, and your loss of
> device is accurately and immediately signalled.
> 
> Quite different.

How can usbip work if networking and usb are so different and what's so
different between vtunerc and usbip, that made it possible to put usbip
into drivers/staging?

Regards,
Andreas

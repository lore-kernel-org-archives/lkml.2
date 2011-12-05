Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab1LEVwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:52:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48055 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932372Ab1LEVwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:52:20 -0500
Date: Mon, 5 Dec 2011 21:54:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, HoP <jpetrous@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
Message-ID: <20111205215405.6ab53357@lxorguk.ukuu.org.uk>
In-Reply-To: <4EDD3583.30405@linuxtv.org>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com>
	<4EDC9B17.2080701@gmail.com>
	<CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com>
	<4EDD01BA.40208@redhat.com>
	<4EDD2C82.7040804@linuxtv.org>
	<20111205205554.2caeb496@lxorguk.ukuu.org.uk>
	<4EDD3583.30405@linuxtv.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How can usbip work if networking and usb are so different and what's so
> different between vtunerc and usbip, that made it possible to put usbip
> into drivers/staging?

Where usbip seems to have remained for a long time without actually being
made useful or correct enough to progress. Meanwhile most remote USB
device access is at a higher level and works beautifully (eg remote USB
printing).

Case proven I think rather than the reverse

Alan

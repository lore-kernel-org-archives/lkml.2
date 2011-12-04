Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1LDOnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 09:43:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45368 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753968Ab1LDOnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 09:43:08 -0500
Date: Sun, 4 Dec 2011 14:44:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: VDR User <user.vdr@gmail.com>
Cc: Walter Van Eetvelt <walter@van.eetvelt.be>,
        Andreas Oberritter <obi@linuxtv.org>, HoP <jpetrous@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
Message-ID: <20111204144442.23d65ae8@lxorguk.ukuu.org.uk>
In-Reply-To: <CAA7C2qgz1GYhVwXwiO5dt09+Mv0719tfCBmK7ud07RZ2VDNxTw@mail.gmail.com>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<4EDA4AB4.90303@linuxtv.org>
	<CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com>
	<aff8302dd6c3eb047c39d3a2d1fd2382@mail.eetvelt.be>
	<CAA7C2qgz1GYhVwXwiO5dt09+Mv0719tfCBmK7ud07RZ2VDNxTw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> While I agree with your more broad view of the issue, I specifically
> talked about VDR.  AFAIK Klaus has no intention of adding true
> server/client support to VDR, so for VDR users, this sounds like it
> could be a working solution without the strict limitations of
> streamdev.

So fix Klaus rather than mess up the kernel.

If you are trying to solve a VDR political problem then kernel hacks are
not the way to go. Someone who cares about it needs to fix VDR, with or
without its current maintainer.

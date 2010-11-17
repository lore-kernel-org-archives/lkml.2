Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935021Ab0KQQbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:31:45 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:65192 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934993Ab0KQQbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:31:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19684.875.53178.598048@quad.stoffel.home>
Date: Wed, 17 Nov 2010 11:31:39 -0500
From: "John Stoffel" <john@stoffel.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
In-Reply-To: <20101116231023.GB27594@tango.0pointer.de>
References: <1289922400.1253.3.camel@yio.site>
	<20101116155717.6671e484@lxorguk.ukuu.org.uk>
	<AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
	<20101116171447.29336514@lxorguk.ukuu.org.uk>
	<AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
	<20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
	<20101116213622.GA17824@tango.0pointer.de>
	<20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk>
	<20101116231023.GB27594@tango.0pointer.de>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Lennart" == Lennart Poettering <mzxreary@0pointer.de> writes:

Lennart> When two users A and B are logged in, on tty1 resp. tty2,
Lennart> then as long as tty1 is active user A should get access to
Lennart> the sound card, usb key, .... As soon as we switch to tty2
Lennart> user B should.

Hmm, it's an interesting idea, and I run into this myself when my son
logs into my desktop as himself and wants to hear sound.

But I wonder how do you handle the case where there are multiple seats
(KVM+S) on one system?  Do you have a mapping table?  

John

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab1GXRQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 13:16:39 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:51665 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab1GXRQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 13:16:34 -0400
MIME-Version: 1.0
In-Reply-To: <20110724101323.d5c9bc5a.rdunlap@xenotime.net>
References: <CAGq3pz4VHgagUQ+jGJdt9LL4UnFt+CDgcLLXbuVeKfWMc=0wAA@mail.gmail.com>
	<20110723202032.67ebdbcc.rdunlap@xenotime.net>
	<CAGq3pz6L5VzYaGBN8Py3x9s-orAp9AoG1OMM=1p8KJ1b3TVR6Q@mail.gmail.com>
	<20110724101323.d5c9bc5a.rdunlap@xenotime.net>
Date: Sun, 24 Jul 2011 18:16:33 +0100
X-Google-Sender-Auth: yG5gRNSLx9r0A_QXmByEw9ybvKA
Message-ID: <CAGq3pz4s-Ff1dhW8TNWT0AP_2+AyTNpOroe4b7VYg254+t78_g@mail.gmail.com>
Subject: Re: OLPC power management patches - merge for 3.1?
From: Daniel Drake <dsd@laptop.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>, tglx@linutronix.de,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 July 2011 18:13, Randy Dunlap <rdunlap@xenotime.net> wrote:
> You can't do both of those AFAIK -- and it already depends on POWER_SUPPLY.
> I guess you could remove "depends on POWER_SUPPLY" and add "select POWER_SUPPLY".
> I'll see if that works.

It does indeed. I'm just wrapping up testing it and making sure that
all the other options are fine.

Thanks,
Daniel

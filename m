Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0GMJpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:45:38 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34516 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab0GMJpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=oE/9Ax7GFAhB2aqex32MsqIkusTjPtwcZu/o39C9VhOTx6/LYmqVM48Bnzt5NtgJbl
         fMZFDmOW1fm5aLMrwVcPUJ/LdsWm86KoHo8iiuL3B5qhCoTmHJ7YZqKDRxPe5AOHtHkm
         6lxGH7/2TIN2UFcMQVnV7VORKc8CmuRqPV7Ac=
MIME-Version: 1.0
Date: Tue, 13 Jul 2010 17:45:36 +0800
Message-ID: <AANLkTimTN3FZjRAjFDV-3pSnwq9EEPzfs5-xXBH5KomO@mail.gmail.com>
Subject: Question on HPET timer reading from device driver?
From: Samuel Xu <samuel.xu.tech@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI:
I am a freshman for HPET timer. Previously, I use TSC counter, to use
rdtsc to get the time stamp. elapsed cycle can be counter from 2 time
stamps.
As a advanced replacement of TSC, I suppose HPET timer can be
conveniently to read time stamp from both kernel mode user  and user
mode apps.
While I failed to find a way to get time stamp value of HPET in Linux
kenerl (I am doing a driver and want to know elapsed cycle from driver
code).

I tried hpet_readl() from my driver code, while hit compiling error.
Is it a correct API for kernel driver to invoke?
I also read the Linux Documentation of HPET, which contain a user mode
demo app to generate a periodic timer via HPET, while missing the time
stamp reading.

Any hint?

Thanks!

Samuel

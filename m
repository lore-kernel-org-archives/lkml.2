Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab0FSUWO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 16:22:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34537 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab0FSUWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 16:22:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=dDJ7pLgjSs3NQj+N9498sJdqYQqQkYLQFkw/+DcO1pi+SIvtw4l9JIwB482b/fiTof
         ceyIt84z7ZNyGNKp+APzYBAdVbPgKO6lUbHFJoxYhJCMzx9MIfx59Xh1uS1+bHv6fPw8
         jLk8X9X65t6wZ2BBmFpvV6Wb88bw2+OVci8Ok=
MIME-Version: 1.0
Date: Sat, 19 Jun 2010 16:22:12 -0400
Message-ID: <AANLkTim7_OzJfwbtk0fE5ScH8zZwZ_uJeo5pJFOhkHu_@mail.gmail.com>
Subject: Dell PowerEdge 4200 scsi, worked in 2.6.18, not in 2.6.26 (LOW 
	PRIORITY help request)
From: trouble daemon <troubledaemon@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel hackers,

I consider this to be of rather low priority given the age of the
hardware, so ignore unless you feel like helping a fellow out, thanks!

I have a pair of Dell PowerEdge 4200's (dual 300 SMP, 512mb, SCA
hotswap scsi, have AMI MegaRaid but removed, same problem with or
without). I am using Debian Lenny, but have used etch (and in fact
bootstrap via FAI from etch currently). The 2.6.18 kernel that comes
with etch works fine in etch and Lenny, but when I tried to use the
2.6.26 kernel in Lenny, the kernel starts to panic (see "dmesg pastes"
below for output).

Ultimately, I was wondering if anyone might be able to take a look at
my dmesg's that might have any idea as to what feature might be new in
.26 that could be responsible for the panic. Sadly, it takes about 5
hours to do a clean run of make-kpkg in debian on these machines, and
I am not setup for distcc or cross compile on my x64 machine yet, so
it is a painful experience to recompile over and over to try figure
out what kernel feature it might be that is causing this.

I should note that I have tried one recompile of 2.6.26 (debianized)
to disable the new aic7xxx module and only use the old driver, but to
no avail. I am looking to try the 2.6.34 vanilla kernel next however.


dmesg pastes
---------------------
I have uploaded the panic dmesg to pastebin at (never expires):
http://pastebin.ca/1886636
I have uploaded the working 2.6.18 dmesg to pastbin at (never
expires): http://pastebin.ca/1886641


I think that about does it as far as pastebins go, but feel free to
ask for more information if you think you might have any idea. Since I
am not an LKML subscriber yet, I would please ask that any replies be
sent to this email address directly. Much appreciated for any help in
advance, thanks!



troubled

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0FWRQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:16:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42805 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab0FWRQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:16:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=n1h3eJHB1pJdEJRIjz9XxnMeoc6USjpVhJJEBQlrD+kAhAejOnad3oMsInUFku453c
         oI95fyZfypRPtZMYxMWNB/84wGgJ13pPj/S6EdkOYlsnVj81A0wZtmKYPdl6iSZOx1QN
         OrcgB9X9P6r59hYSKD75T/EJq1wl6P10sNNQw=
MIME-Version: 1.0
Date: Wed, 23 Jun 2010 13:16:51 -0400
X-Google-Sender-Auth: -f8jFPmowVH2VtNS6QsFg21KlTs
Message-ID: <AANLkTim362_xv5FAyFSpdnAFUlILliEoGBW8_oZ4QVj1@mail.gmail.com>
Subject: i915: Dell E6410 Ironlake LVDS detection
From: Ben Guthro <ben@guthro.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a problematic machine, that I have traced the problem down to
what I think is an issue with the i915 detection of the LVDS on the
Ironlake chip.

The machine in question is a Dell Latitude E6410 - i5 quad core
laptop, with the intel Ironlake chip, and the failure condition is
such that when the boot sequence switches into KMS mode, the screen
goes black, and never comes back.

My base install is Ubuntu 10.04, and I've spun through a few kernels
to try to bisect the problem. Unfortunately, I've been unable to find
a kernel that works (including the 2.6.35 RC's, and an ubuntu build of
drm-intel-next from the beginning of June)

I can get the machine to come up on an external display, if switched
at the BIOS screen...but /sys/class/card0 never shows an LVDS
connector...and dmesg doesn't seem to be throwing any errors.

If you have any thoughts on what I might try next, in attempting to
debug this issue, I'd appreciate any pointers, as the intel cards
isn't my particular area of expertise, but am capable enough to read
the code...


Regards,

Ben Guthro

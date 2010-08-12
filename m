Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223Ab0HLPFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:05:49 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58486 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759790Ab0HLPFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:05:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=xb6ML0J6sgUHKoCtyIwZoFn70caLxtwGRGpZqdyfZNVFFZKaRwUCpo/Nz7vER9fDNg
         nGgSwG2Wp40YlujVmkmVIQESIKL2K0aQEh1TSzjMTcmbgZmr85Kp4b4sd+3ZW1bVyjRz
         2d6z8bwDyyLaqLJrBZyo5CVBMTREbRFxssGWg=
MIME-Version: 1.0
Date: Thu, 12 Aug 2010 17:05:42 +0200
X-Google-Sender-Auth: wpw0a4IzVeZ1ZCB9tkd6yFUbwFU
Message-ID: <AANLkTik1K3AMQhT+HA7z33A3BpE+UXPJ+a14qNT=mgz7@mail.gmail.com>
Subject: [ANNOUNCE] [REALTIME] 2.6.33.8-rt30-jk
From: John Kacur <jkacur@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of 2.6.33.8-rt30-jk
The -jk indicates that it is my own -rt version, and not the official
one that Thomas releases.
However, it would be great if you tested it and reported your results.

You can fetch it via git from
git://git.kernel.org/pub/scm/linux/kernel/git/jkacur/jk-2.6.git
branch: rt/2.6.33-jk

Thanks, enjoy!

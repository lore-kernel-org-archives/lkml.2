Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab1J0TFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 15:05:00 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47245 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1J0TE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 15:04:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAGpevg-JhuxLp+59N+DUGHUwe3M3qrdyocEfLgtvOE4e8+Uu1A@mail.gmail.com>
References: <20111018190255.7837.17923.malonedeb@chaenomeles.canonical.com>
	<20111026210627.20335.40050.malone@wampee.canonical.com>
	<CAGpevg-JhuxLp+59N+DUGHUwe3M3qrdyocEfLgtvOE4e8+Uu1A@mail.gmail.com>
Date: Thu, 27 Oct 2011 22:04:58 +0300
Message-ID: <CAGpevg_d81CwTR=uoDf90iuoTWg6uEiTogO4Bp08fE5Ku9TrxQ@mail.gmail.com>
Subject: [Bug 877666] Dell XT2 touchpad not recognized
From: Lasse Penttinen <lasse.penttinen@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kernel Devs,

I was asked by Ubuntu team to report this bug upstream (my 1st).
However the kernel.org bugzilla seems to be down, so mailing list is
my only alternative. Unfortunately I did not find any template or such
for reporting via email, so here goes.

Bug description: The touchpad of Dell XT2 is recognized as a plain
PS/2 mouse, and therefore any touchpad related settings are not
available (like disabling it while typing..)

Reproducable: I have reproduced this with Ubuntu 11.10
(3.0.0-12-generic) and with Fedora 16 beta live CD just to make sure.

Here is the link to original Launchpad report (with a lot of attached
data): https://bugs.launchpad.net/ubuntu/+source/linux/+bug/877666

Cheers,
Lasse

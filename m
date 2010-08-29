Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab0H2TYZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 15:24:25 -0400
Received: from void.printf.net ([89.145.121.20]:51872 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab0H2TYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 15:24:24 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.36-rc3
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com>
Date: Sun, 29 Aug 2010 15:24:17 -0400
In-Reply-To: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com>
	(Linus Torvalds's message of "Sun, 29 Aug 2010 10:25:21 -0700")
Message-ID: <m3hbid2pem.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Signed-off-by: Darren Hart (3):
>       powerpc: Re-enable preemption before cpu_die()
>       powerpc: Silence __cpu_up() under normal operation
>       powerpc: Silence xics_migrate_irqs_away() during cpu offline

FWIW, the S-o-b tag got into the author field here.

(Looking at `git log --author="Signed-off-by"`, this has happened a
couple of times before.  Might be worth stripping automatically.)

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

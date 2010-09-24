Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab0IXMVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:21:54 -0400
Received: from anguilla.debian.or.at ([86.59.21.37]:54530 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab0IXMVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:21:53 -0400
Date: Fri, 24 Sep 2010 14:21:52 +0200
From: Peter Palfrader <peter@palfrader.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.32.22: panic in put_cred_rs()
Message-ID: <20100924122152.GV9394@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

one of my x86_64 servers running 2.6.32.22 to host maybe a dozen KVM
domains panicked a couple minutes ago.

| Kernel panic - not syncing: CRED: put_cred_rcu() sees [..] with usage [...]
| trace:
|         panic
|         file_free_rcu
|         sched_clock
|         put_cred_rcu
|         __rcu_process_callbacks
|         rcu_process_callback
|         s__do_softirc
|         call_softirc
|         do_softirc
|         irq_exit
|         smp_apic_timer_interrupt
|         apic_timer_interrupt
|         mwait_idle
|         enter_idle
|         cpu_idle
|         start_secondary

The full call trace can be found at
http://asteria.noreply.org/~weasel/volatile/2010-09-24-RKPcUNi7HW4/panic-2.6.32.22.png

Cheers,
Peter
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/

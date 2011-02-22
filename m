Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab1BVFkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 00:40:09 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:57332 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab1BVFkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 00:40:07 -0500
Date: Tue, 22 Feb 2011 14:39:32 +0900
From: Norbert Preining <preining@logic.at>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jirislaby@gmail.com>,
        stefanb@linux.vnet.ibm.com,
        linux-pm <linux-pm@lists.linux-foundation.org>, stable@kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.37.1 s2disk regression (TPM)
Message-ID: <20110222053932.GB21903@gamma.logic.tuwien.ac.at>
References: <4D60E93D.1050205@gmail.com> <4D60F108.9000106@gmail.com> <201102201151.11635.rjw@sisk.pl> <201102201248.10779.rjw@sisk.pl> <4D628521.8000205@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D628521.8000205@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

sorry for late reply, was night over here in Japan.

On Mo, 21 Feb 2011, Rajiv Andrade wrote:
> Norbert, can 'cat /sys/devices/pnp0/00\:0*/timeouts' and send the output?

I don't have any of these files:
$ ls /sys/devices/pnp0/*
/sys/devices/pnp0/uevent

/sys/devices/pnp0/00:00:
id  options  power  resources  subsystem  uevent

/sys/devices/pnp0/00:01:
driver	firmware_node  id  options  power  resources  subsystem  uevent

/sys/devices/pnp0/00:02:
firmware_node  id  options  power  resources  subsystem  uevent

/sys/devices/pnp0/00:03:
driver	       id     options  resources  subsystem
firmware_node  nvram  power    rtc	  uevent

/sys/devices/pnp0/00:04:
firmware_node  id  options  power  resources  subsystem  uevent

/sys/devices/pnp0/00:05:
firmware_node  id  options  power  resources  subsystem  uevent

/sys/devices/pnp0/00:06:
firmware_node  id  options  power  resources  subsystem  uevent

/sys/devices/pnp0/00:07:
driver	firmware_node  id  options  power  resources  subsystem  uevent

/sys/devices/pnp0/00:08:
driver	firmware_node  id  options  power  resources  subsystem  uevent

/sys/devices/pnp0/00:09:
firmware_node  id  options  power  resources  subsystem  uevent

/sys/devices/pnp0/00:0a:
active	driver	       id	owned  pubek	  temp_deactivated
cancel	enabled        misc	pcrs   resources  uevent
caps	firmware_node  options	power  subsystem

/sys/devices/pnp0/power:
async		      runtime_status	      wakeup_count
autosuspend_delay_ms  runtime_suspended_time  wakeup_hit_count
control		      runtime_usage	      wakeup_last_time_ms
runtime_active_kids   wakeup		      wakeup_max_time_ms
runtime_active_time   wakeup_active	      wakeup_total_time_ms
runtime_enabled       wakeup_active_count
$

running git kernel 6f576d57f1 (were the commit is reverted)

More I cannot offer ... let me know what else I can provide.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
The major difference between a thing that might go wrong
and a thing that cannot possibly go wrong is that when a
thing that cannot possibly go wrong goes wrong it usually
turns out to be impossible to get at or repair.
                 --- One of the laws of computers and programming revealed.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy

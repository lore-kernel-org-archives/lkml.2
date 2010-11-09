Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab0KIPTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:19:03 -0500
Received: from smtprelay03.ispgateway.de ([80.67.31.37]:45270 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab0KIPS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:18:58 -0500
Message-ID: <4CD966D8.4000602@ladisch.de>
Date: Tue, 09 Nov 2010 16:20:56 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: HPET (?) related hangs and breakage in 2.6.35,36
References: <AANLkTikA6hZDV0A30fku7VT7Z1P8OqxcsF-EK95pBdD=@mail.gmail.com>
In-Reply-To: <AANLkTikA6hZDV0A30fku7VT7Z1P8OqxcsF-EK95pBdD=@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Lutomirski wrote:
> After several minutes of uptime, my system freezes in a strange way.
> All of userspace and some kernel services freeze hard (no mouse, no
> typing, etc.)  Caps-lock works intermittently, as does (I think)
> pinging.  The only debug output I've been able to get is this (typed
> from a blurry photo because netconsole dies along with everything
> else):
> 
> [ 5478.244722] Clocksource tsc unstable (delta = 101399051316 ns)
> [ 5478.367958] Switching to clocksource hpet
> [ 5543.729698] BUG: soft lockup - CPU #1 stuck for 61s! [migration/1:6]

Looks like this one:
http://lkml.org/lkml/2010/10/26/126


Regards,
Clemens

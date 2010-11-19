Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab0KSDXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 22:23:03 -0500
Received: from mail.openrapids.net ([64.15.138.104]:48812 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751173Ab0KSDXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 22:23:01 -0500
Date: Thu, 18 Nov 2010 22:22:59 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Goulet <david.goulet@polymtl.ca>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [RELEASE] Userspace RCU 0.5.2
Message-ID: <20101119032259.GA1085@Krystal>
References: <20101118210232.GA10632@Krystal> <20101119025453.GA7040@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119025453.GA7040@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 22:21:34 up 57 days,  7:23,  3 users,  load average: 0.34, 0.19,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/0.5.1/0.5.2/g

Now works fine on non-x86 architectures. I'll have to be more cautious in the
future for such large changes.

Mathieu

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> Well well, a renaming error seems to have crept into 0.5.0, which caused
> problems with atomic operations on 64-bit architectures.
> 
> I made sure no other similar problem exist. Anyone using 0.5.0 (released a few
> hours ago) should upgrade to 0.5.1.
> 
> Thank you,
> 
> Mathieu
> 
> * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> > liburcu is a LGPLv2.1 userspace RCU (read-copy-update) library. This data
> > synchronization library provides read-side access which scales linearly with the
> > number of cores. It does so by allowing multiples copies of a given data
> > structure to live at the same time, and by monitoring the data structure
> > accesses to detect grace periods after which memory reclamation is possible.
> > 
> > Changelog:
> > 
> > * Version 0.5.0 changes the API presented by memory model, architecture
> >   abstraction and data structure primitives in headers. The prefixes are,
> >   respectively:
> >   - cmm_ : Concurrent Memory Model
> >   - caa_ : Concurrent Architecture Abstraction
> >   - cds_ : Concurrent Data Structures
> > 
> > This will make UST's life easier for instrumentation of large projects like
> > MariaDB and qemu.
> > 
> > Project website: http://lttng.org/urcu
> > Download link: http://www.lttng.org/files/urcu/
> > 
> > 
> > -- 
> > Mathieu Desnoyers
> > Operating System Efficiency R&D Consultant
> > EfficiOS Inc.
> > http://www.efficios.com
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

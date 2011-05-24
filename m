Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab1EXN7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:59:48 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:59372 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab1EXN7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:59:47 -0400
Date: Tue, 24 May 2011 09:59:25 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, fbuihuu@gmail.com, mingo@elte.hu,
        paulus@samba.org, acme@redhat.com
Subject: perf: regression -- missing /sys/devices/system/cpu/perf_events
Message-ID: <alpine.DEB.2.00.1105240955050.9203@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I know this is a bit late, but for some reason our users sit on these 
things and then they aren't willing to take it up with linux-kernel 
themselves

> > > commit 15ac9a395a753cb28c674e7ea80386ffdff21785
> > > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Date:   Mon Sep 6 15:51:45 2010 +0200
> > > 
> > >    perf: Remove the sysfs bits

removed the /sys/devices/system/cpu/perf_events
I thought things in /sys were stable ABI?

Apparently it's common for people to have scripts to check if 
perf_events is available in a kernel by checking the existence of
/sys/devices/system/cpu/perf_events, even if they didn't use the
files within.

Now that 2.6.38 kernels are starting to hit the distros we're getting 
complaints that it's missing.

Vince



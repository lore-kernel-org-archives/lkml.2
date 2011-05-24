Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab1EXRms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:42:48 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:38879 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab1EXRmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:42:47 -0400
Date: Tue, 24 May 2011 13:42:35 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        acme@redhat.com
Subject: Re: perf: regression -- missing
 /sys/devices/system/cpu/perf_events
In-Reply-To: <1306246306.18455.36.camel@twins>
Message-ID: <alpine.DEB.2.00.1105241341160.24062@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105240955050.9203@cl320.eecs.utk.edu> <1306246306.18455.36.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Peter Zijlstra wrote:

> A much more reliable way is simply doing the syscall and seeing what
> happens. But if you want to poke around in sysfs, /sys/bus/event_source/
> is the new location.

It's been suggested that they can look for the existence of:
  /proc/sys/kernel/perf_event_paranoid

is that something not likely to go away?

Vince   

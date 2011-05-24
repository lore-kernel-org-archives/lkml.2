Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab1EXUNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 16:13:00 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:45228 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839Ab1EXUM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 16:12:59 -0400
Date: Tue, 24 May 2011 16:12:49 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com
Subject: Re: perf: regression -- missing
 /sys/devices/system/cpu/perf_events
In-Reply-To: <20110524194810.GB27634@elte.hu>
Message-ID: <alpine.DEB.2.00.1105241610390.24062@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105240955050.9203@cl320.eecs.utk.edu> <1306246306.18455.36.camel@twins> <alpine.DEB.2.00.1105241341160.24062@cl320.eecs.utk.edu> <20110524194810.GB27634@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Ingo Molnar wrote:
> 
> So, what is wrong with the method Peter suggested: the presence of the perf 
> syscall (it not returning -ENOSYS) is bona fide evidence that perf is 
> available.

it's just hard to do that from a shell script.

also, running the perf syscall can be tricky if you have a new kernel but 
an older set of header files that doesn't have the syscall number defined.

Vince
vweaver1@eecs.utk.edu

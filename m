Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab2JMJvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 05:51:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44952 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2JMJvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 05:51:33 -0400
Date: Sat, 13 Oct 2012 02:51:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Ezequiel Garcia <elezegarcia@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Tim Bird <tim.bird@am.sony.com>,
        celinux-dev@lists.celinuxforum.org
Subject: Re: [Q] Default SLAB allocator
In-Reply-To: <m2391ktxjj.fsf@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1210130249070.7462@chino.kir.corp.google.com>
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com> <m27gqwtyu9.fsf@firstfloor.org> <alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com> <m2391ktxjj.fsf@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012, Andi Kleen wrote:

> When did you last test? Our regressions had disappeared a few kernels
> ago.
> 

This was in August when preparing for LinuxCon, I tested netperf TCP_RR on 
two 64GB machines (one client, one server), four nodes each, with thread 
counts in multiples of the number of cores.  SLUB does a comparable job, 
but once we have the the number of threads equal to three times the number 
of cores, it degrades almost linearly.  I'll run it again next week and 
get some numbers on 3.6.

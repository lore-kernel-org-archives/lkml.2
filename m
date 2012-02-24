Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab2BXXvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 18:51:53 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55872 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2BXXvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 18:51:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rientjes@google.com designates 10.68.208.196 as permitted sender) smtp.mail=rientjes@google.com; dkim=pass header.i=rientjes@google.com
Date: Fri, 24 Feb 2012 15:51:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Josef Bacik <josef@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        linux-mm@kvack.org, Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: add sysctl to enable slab memory dump
In-Reply-To: <CAOJsxLHEAZbN-sPeJ10qAN-HVEj0Rq_RkLt0QCvZHhZitW+9pw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1202241550080.2401@chino.kir.corp.google.com>
References: <20120222115320.GA3107@x61.redhat.com> <alpine.DEB.2.00.1202221640420.14213@chino.kir.corp.google.com> <20120223150238.GA15427@dhcp231-144.rdu.redhat.com> <alpine.DEB.2.00.1202231505080.26362@chino.kir.corp.google.com> <20120224151025.GA1848@localhost.localdomain>
 <alpine.DEB.2.00.1202241342240.22880@chino.kir.corp.google.com> <CAOJsxLHEAZbN-sPeJ10qAN-HVEj0Rq_RkLt0QCvZHhZitW+9pw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-1208381419-1330127511=:2401"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-1208381419-1330127511=:2401
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 24 Feb 2012, Pekka Enberg wrote:

> On Fri, 24 Feb 2012, Josef Bacik wrote:
> >> Um well yeah, I'm rewriting a chunk of btrfs which was rapantly leaking memory
> >> so the OOM just couldn't keep up with how much I was sucking down.  This is
> >> strictly a developer is doing something stupid and needs help pointing out what
> >> it is sort of moment, not a day to day OOM.
> 
> On Fri, Feb 24, 2012 at 11:45 PM, David Rientjes <rientjes@google.com> wrote:
> > If you're debugging new kernel code and you realize that excessive amount
> > of memory is being consumed so that nothing can even fork, you may want to
> > try cat /proc/slabinfo before you get into that condition the next time
> > around, although I already suspect that you know the cache you're leaking.
> > It doesn't mean we need to add hundreds of lines of code to the kernel.
> > Try kmemleak.
> 
> Kmemleak is a wonderful tool but it's also pretty heavy-weight which
> makes it inconvenient in many cases.
> 

Too heavyweight to enable when debugging issues after "rewriting a chunk" 
of a filesystem that manipulates kernel memory?  I can't imagine a better 
time to enable it.
--397155492-1208381419-1330127511=:2401--

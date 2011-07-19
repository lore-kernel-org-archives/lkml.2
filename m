Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab1GSItc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 04:49:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36188 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1GSItb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 04:49:31 -0400
Subject: Re: [Patch] mm: make CONFIG_NUMA depend on CONFIG_SYSFS
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <amwang@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
        linux-mm@kvack.org
In-Reply-To: <4E252CA1.803@redhat.com>
References: <1310987909-3129-1-git-send-email-amwang@redhat.com>
	 <20110718135243.GA5349@suse.de>  <4E25221F.6060605@redhat.com>
	 <1311058498.16961.15.camel@edumazet-laptop>  <4E252CA1.803@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 10:49:21 +0200
Message-ID: <1311065361.2375.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 19 juillet 2011 à 15:05 +0800, Cong Wang a écrit :
> 于 2011年07月19日 14:54, Eric Dumazet 写道:
> > Le mardi 19 juillet 2011 à 14:20 +0800, Cong Wang a écrit :
> >
> >> Hmm, since we don't have to enable SYSFS for NUMA, how about
> >> make a new Kconfig for drivers/base/node.c? I.e., CONFIG_NUMA_SYSFS,
> >> like patch below.
> >>
> >
> > I dont quite understand this patch, nor the idea behind it.
> >
> > You can have a NUMA kernel (for appropriate percpu locality or whatever
> > kernel data), and yet user land processes unable to use numactl if SYSFS
> > is not enabled. I dont see a problem.
> >
> 
> Both Pekka and Mel pointed out that it makes sense to have NUMA kernel
> without SYSFS, this means sysfs interface is not a must for NUMA kernel.
> Thus, I think it makes sense to separate the numa sysfs code out.

Sorry, I misread the patch, I was confused by the title, since it still
claims "make CONFIG_NUMA depend on CONFIG_SYSFS" ;)




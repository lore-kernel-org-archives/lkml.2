Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab0EMOEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 10:04:25 -0400
Received: from tango.0pointer.de ([85.214.72.216]:50716 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab0EMOEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 10:04:24 -0400
Date: Thu, 13 May 2010 16:03:54 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, James Kosin <jkosin@intcomgrp.com>,
       linux-kernel@vger.kernel.org, menage@google.com,
       balbir@linux.vnet.ibm.com, jsafrane@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
Message-ID: <20100513140354.GA12639@tango.0pointer.de>
References: <eJjRf-6YM-1@gated-at.bofh.it>
 <eJktY-7JG-7@gated-at.bofh.it>
 <eJktY-7JG-5@gated-at.bofh.it>
 <4BEAB6FC.8090105@intcomgrp.com>
 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
 <1273674048.1626.117.camel@laptop>
 <20100512190757.GA421@tango.0pointer.de>
 <1273755719.5605.3537.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273755719.5605.3537.camel@twins>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13.05.10 15:01, Peter Zijlstra (peterz@infradead.org) wrote:

> 
> On Wed, 2010-05-12 at 21:07 +0200, Lennart Poettering wrote:
> > See Dhaval's patch on the background of systemd
> > (http://0pointer.de/blog/projects/systemd.html). When a service is
> > started in systemd, we create a cgroup for it, when it ends, we remove
> > it. 
> 
> I seriously hope that's optional, because I for one would really hate a
> system that does that. I still mostly build kernels with only cpuset in
> and really don't want anybody but me creating groups in there.

By default systemd will create its groups in the "debug" hierarchy, (at
least for now, in the long run i'd like to see "noop" hierarchy or so,
that doesn't sound so temporary), since that controller is not useful
for anything but keeping track of processes. So it shouldn't bother you
at all.

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2GOKOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 06:14:55 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:33282 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2GOKOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 06:14:50 -0400
Date: Sun, 15 Jul 2012 12:14:34 +0200
From: Borislav Petkov <bp@amd64.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
Message-ID: <20120715101434.GA18144@aftab.osrc.amd.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <1342212885.25704.4.camel@lade.trondhjem.org>
 <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
 <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 03:12:05PM +0300, Pekka Enberg wrote:
> We have "make kvmconfig" in the KVM tool tree that pretty much does
> that automatically. There's nothing tools/kvm specific about it so I
> guess you could merge that separately.

Yes, something like KVMTOOL_TEST_ENABLE except not a make target but a
Kconfig option.

I can imagine a user selecting this and other coarse-grained options
in Kconfig and then "adjusting" single options like, for example, I
wouldn't need the *9P* options on x86, etc, etc.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab2GSSJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:09:20 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39928 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2GSSJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:09:17 -0400
Date: Thu, 19 Jul 2012 20:09:14 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Pekka Enberg <penberg@kernel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
Message-ID: <20120719180914.GG23393@aftab.osrc.amd.com>
References: <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
 <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
 <20120714124332.GA4093@moon>
 <20120714174827.GA13319@aftab.osrc.amd.com>
 <20120719144217.GC16873@home.goodmis.org>
 <20120719164807.GD23393@aftab.osrc.amd.com>
 <1342717366.12353.48.camel@gandalf.stny.rr.com>
 <20120719173415.GE23393@aftab.osrc.amd.com>
 <1342720646.12353.67.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1342720646.12353.67.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 01:57:26PM -0400, Steven Rostedt wrote:
> Yes, I know you know this already, as we discussed it in a pub over a
> beer (choir practice). But this is a public forum on LKML (the church),
> where I now have an audience of heathens. Convert! Convert! You are all
> sinners!

Ah, gotcha.

[ … ]

> But this still doesn't solve Linus's initial request. That would be a
> single option that makes your distro boot, and work well. Again, that
> option wont have the drivers needed, but it will enable all the core
> infrastructure that you need.

Oh I'm being additive here. You'll have feature profiles for the stuff
we talk above and distro profiles which solve Linus' issue. Basically
one coarse-grained config option will either select a feature which has
a lot of small subfeatures of which some are sane and want to be enabled
by default when selecting the topfeature.

Or a distro-specific feature which could itself select other
topfeatures.

I haven't tried this in reality to actually be able to say that a
tree-like configure approach would actually make sense and work. It
sounds like a nice idea though, especially having the hierarchical
structure. :)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab2GSSzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:55:41 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:1360 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254Ab2GSSzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:55:38 -0400
Message-ID: <1342724136.26179.44.camel@x61.thuisdomein>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Josh Boyer <jwboyer@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Date: Thu, 19 Jul 2012 20:55:36 +0200
In-Reply-To: <CAMuHMdWunmaTvF3sEfWBtRfczwY01RDzvcX_hTWe2Q62RpCwHA@mail.gmail.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	 <20120713210240.GG1707@redhat.com>
	 <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
	 <20120719152618.GD16873@home.goodmis.org>
	 <20120719154521.GC8469@zod.bos.redhat.com>
	 <1342714088.12353.33.camel@gandalf.stny.rr.com>
	 <20120719171918.GD8469@zod.bos.redhat.com>
	 <1342722036.26179.40.camel@x61.thuisdomein>
	 <20120719182235.GG8469@zod.bos.redhat.com>
	 <CAMuHMdWunmaTvF3sEfWBtRfczwY01RDzvcX_hTWe2Q62RpCwHA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 19 Jul 2012 18:55:37.0174 (UTC) FILETIME=[15852760:01CD65E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 20:49 +0200, Geert Uytterhoeven wrote:
> > I believe Alan was more correct than me when he said it was 'make
> > oldconfig' that produced the warnings.
> 
> Kconfig does spit out warnings for selecting things with unmet dependencies.
> But does anyone care?
> 
> [...checking logs...]
> 
> Oh, only 12 warnings in the v3.5-rc7 builds. Not that bad as my gut feeling
> said...

Well, that's yet another issue but anyhow. That number of warnings
should presumably drop to (almost) zero if those weren't warnings but
errors. Has that ever been tried?


Paul Bolle


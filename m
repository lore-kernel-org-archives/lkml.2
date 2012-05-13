Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab2EMNHo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 09:07:44 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:41352 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab2EMNHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 09:07:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] MAINTAINERS: Add myself as the cpufreq maintainer
Date: Sun, 13 May 2012 15:12:36 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, cpufreq@vger.kernel.org
References: <20120504160417.GA421@redhat.com> <201205112135.46097.rjw@sisk.pl> <20120513101931.39617e4909fcc10d6739bc75@canb.auug.org.au>
In-Reply-To: <20120513101931.39617e4909fcc10d6739bc75@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201205131512.36250.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Sunday, May 13, 2012, Stephen Rothwell wrote:
> Hi Rafael,  Dave,
> 
> On Fri, 11 May 2012 21:35:45 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Since cpufreq has no official maintainer at the moment, I'm willing
> > to maintain it along some other power management core code I've been
> > maintaining already.
> 
> I have cpufreq-current and cpufreq trees in linux-next (both currently
> empty and with Dave as contact).  What should I do with them?
> 
> cpufreq-current	git://git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git#fixes
> cpufreq		git://git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git#next

I will push future cpufreq updates through the linux-pm tree.

Thanks,
Rafael

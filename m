Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1JSF2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 01:28:22 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33484 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752007Ab1JSF2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 01:28:21 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18bPdk5rnIb5fonGEY2sH8JMS/buUw83i82RR8dAE
	+LdLPPsA5A65Ae
Subject: Re: patch] cpusets, cgroups: disallow attaching kthreadd
From: Mike Galbraith <efault@gmx.de>
To: Paul Menage <paul@paulmenage.org>
Cc: David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <CALdu-PDP5ytAk_W+yUZ4dkJLW_z=sy1jgds2V=4GHykepM_Ufg@mail.gmail.com>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	 <1316770936.6641.11.camel@marge.simson.net>
	 <1316775204.7562.9.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
	 <1316788392.6544.33.camel@marge.simson.net>
	 <1318224892.6161.45.camel@marge.simson.net>
	 <1318233815.6527.5.camel@marge.simson.net>
	 <1318925436.9641.23.camel@marge.simson.net>
	 <1318927355.21167.3.camel@twins>
	 <1318927629.9641.27.camel@marge.simson.net>
	 <1318928763.21167.5.camel@twins>
	 <1318929825.9641.32.camel@marge.simson.net>
	 <1318932693.6748.5.camel@marge.simson.net>
	 <alpine.DEB.2.00.1110181336150.2639@chino.kir.corp.google.com>
	 <1318996839.6222.20.camel@marge.simson.net>
	 <CALdu-PA7+bygEP-44XB8evaTrsZiDopc-24SmUV+0NbiA=sHNw@mail.gmail.com>
	 <CALdu-PDP5ytAk_W+yUZ4dkJLW_z=sy1jgds2V=4GHykepM_Ufg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Oct 2011 07:28:16 +0200
Message-ID: <1319002096.6222.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 21:56 -0700, Paul Menage wrote:
> On Tue, Oct 18, 2011 at 9:53 PM, Paul Menage <paul@paulmenage.org> wrote:
> >
> > I can see the argument that the number of use-cases for this is fairly
> > small, but in line with the principle of keeping the ABI as stable as
> > possible in the absence of bugs that force a change, having the
> > restriction in the necessary subsystems seems cleaner.
> >
> 
> Separately, an alternative fix for the cpusets case be to make it
> always possible to move a thread to the root cpuset, even if it's
> PF_THREAD_BOUND?

Yeah, an escape hatch is what I did first.

https://lkml.org/lkml/2011/9/23/14

	-Mike


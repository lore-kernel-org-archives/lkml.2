Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab0FMQIF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 12:08:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49917 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab0FMQID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 12:08:03 -0400
Date: Sun, 13 Jun 2010 18:07:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16054] UML broken for CONFIG_SLAB
Message-ID: <20100613160757.GB5623@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Parag Warudkar <parag.lkml@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
 <YPGdyfWGvNK.A.KHH.75OFMB@chimera>
 <AANLkTikKQBrH6rvsj-6chzYqd8NUsmEQBGD2jvTvpJVf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikKQBrH6rvsj-6chzYqd8NUsmEQBGD2jvTvpJVf@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Parag Warudkar <parag.lkml@gmail.com>
Date: Sun, Jun 13, 2010 at 11:35:34AM -0400

> On Sun, Jun 13, 2010 at 10:49 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16054
> > Subject         : UML broken for CONFIG_SLAB
> > Submitter       : Parag Warudkar <parag.lkml@gmail.com>
> > Date            : 2010-05-23 21:40 (22 days old)
> > Message-ID      : <alpine.DEB.2.00.1005231149100.605@parag-laptop>
> > References      : http://marc.info/?l=linux-kernel&m=127465083806617&w=2
> 
> Borislav,
> 
> I believe both of the issues I encountered that are part of this bug
> entry (missing/superfluous slab inclusion issues and cfq related boot
> crash due to popcnt/hweight stuff) have a known fix [1] but I am not
> sure if any of it actually landed in -git. Quick search through
> git.kernel.org log doesn't show anything relevant.

I don't know whether the SLAB issue is related but
the hweight fix is in -tip and hasn't gone mainline yet:
http://git.kernel.org/tip/055c47272b8f5679d08ccc57efea3cb4aaeb5fc6

-- 
Regards/Gruss,
    Boris.

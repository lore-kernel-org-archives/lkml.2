Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1JYImN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:42:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59635 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab1JYImJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:42:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: linux-next: manual merge of the pm tree with the s390 tree
Date: Tue, 25 Oct 2011 10:44:40 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20111025182025.d57f82a57ceaa8fae7cc5127@canb.auug.org.au> <201110251039.46327.rjw@sisk.pl> <20111025104005.733cd419@de.ibm.com>
In-Reply-To: <20111025104005.733cd419@de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110251044.40354.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 25, 2011, Martin Schwidefsky wrote:
> On Tue, 25 Oct 2011 10:39:46 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Tuesday, October 25, 2011, Stephen Rothwell wrote:
> > > Hi Rafael,
> > > 
> > > Today's linux-next merge of the pm tree got a conflict in
> > > arch/s390/kernel/suspend.c between commit 4de2166b1804 ("[S390] sparse:
> > > fix sparse warnings about missing prototypes") from the s390 tree and
> > > commit 85055dd805f0 ("PM / Hibernate: Include storage keys in hibernation
> > > image on s390") from the pm tree.
> > > 
> > > I fixed it up (see below) and can carry the fix as necessary.
> > 
> > The fix looks correct to me, so please carry it going forward (unless
> > Martin decides to pull it into his tree).
> 
> I could add the git commit 85055dd805f0 from the pm tree to git390 and fix
> the merge conflict in the new sparse patch. Dunno if it is worthwhile.

Not really.  I think the conflict is easy enough to handle at merge time.

Thanks,
Rafael

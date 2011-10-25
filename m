Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1JYIkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:40:12 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:51721 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab1JYIkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:40:10 -0400
Date: Tue, 25 Oct 2011 10:40:05 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: manual merge of the pm tree with the s390 tree
Message-ID: <20111025104005.733cd419@de.ibm.com>
In-Reply-To: <201110251039.46327.rjw@sisk.pl>
References: <20111025182025.d57f82a57ceaa8fae7cc5127@canb.auug.org.au>
	<201110251039.46327.rjw@sisk.pl>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011 10:39:46 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday, October 25, 2011, Stephen Rothwell wrote:
> > Hi Rafael,
> > 
> > Today's linux-next merge of the pm tree got a conflict in
> > arch/s390/kernel/suspend.c between commit 4de2166b1804 ("[S390] sparse:
> > fix sparse warnings about missing prototypes") from the s390 tree and
> > commit 85055dd805f0 ("PM / Hibernate: Include storage keys in hibernation
> > image on s390") from the pm tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary.
> 
> The fix looks correct to me, so please carry it going forward (unless
> Martin decides to pull it into his tree).

I could add the git commit 85055dd805f0 from the pm tree to git390 and fix
the merge conflict in the new sparse patch. Dunno if it is worthwhile.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


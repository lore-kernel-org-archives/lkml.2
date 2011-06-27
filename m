Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab1F0RCC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 13:02:02 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18989 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab1F0RB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 13:01:56 -0400
Date: Mon, 27 Jun 2011 10:01:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Dike <jdike@addtoit.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: Tree for June 27 (uml)
Message-Id: <20110627100119.9bebaa5b.randy.dunlap@oracle.com>
In-Reply-To: <20110627164259.GF11013@ZenIV.linux.org.uk>
References: <20110627161656.688820b9.sfr@canb.auug.org.au>
	<20110627082733.75e58ae4.randy.dunlap@oracle.com>
	<201106271830.43698.richard@nod.at>
	<20110627164259.GF11013@ZenIV.linux.org.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4E08B770.0146:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011 17:42:59 +0100 Al Viro wrote:

> On Mon, Jun 27, 2011 at 06:30:43PM +0200, Richard Weinberger wrote:
> > Am Montag 27 Juni 2011, 17:27:33 schrieb Randy Dunlap:
> > > On Mon, 27 Jun 2011 16:16:56 +1000 Stephen Rothwell wrote:
> > > > Hi all,
> > > 
> > > > Changes since 20110624:
> > > uml defconfig builds on x86 (32-bit and 64-bit) fail with:
> > > 
> > > fs/hostfs/hostfs_kern.c:756: error: 'mask' undeclared (first use in this
> > > function)
> > 
> > Hmm, "->permission() sanitizing: don't pass flags to ->permission()" is the evil doer.
> > Al?
> 
> Gyah... s/mask/desired/ in that line.  Will fold...

Ack, that works, thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

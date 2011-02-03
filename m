Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab1BCPT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:19:58 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:32962 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752435Ab1BCPT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:19:57 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: _L3Z_gUVM1nKqFW1ggICb3FxPFAP9A0V2iRfDOow9tUL_ES
 6_3zryTp2.7Zd6AexaqUZzikL8a72yT2Ec0wohGbJRQtZSEsnE6s0MTVxYm7
 uFj5dGN.e0T1eel1wS8jDMz8BmzpHHtOCMGnOifCZsL9PGl13cKewKMwUJRc
 da0qoq7KrPpQJUBLemS_5UHR4nxIPl3ukMrI0tL.Mk9Qq52dsGGvJ8sA0CQr
 sR.KgF2IG2rrQcAUCq7ydIkBofTHEVyOW3LYr
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 3 Feb 2011 09:19:54 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Theodore Tso <tytso@MIT.EDU>
Subject: Re: linux-next: build failure after merge of the slab tree
In-Reply-To: <1296502339.30654.13.camel@jaguar>
Message-ID: <alpine.DEB.2.00.1102030919380.6519@router.home>
References: <20110131144246.dfa2abe3.sfr@canb.auug.org.au> <1296502339.30654.13.camel@jaguar>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, Pekka Enberg wrote:

> On Mon, 2011-01-31 at 14:42 +1100, Stephen Rothwell wrote:
> > Hi all,
> >
> > After merging the slab tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >
> > fs/ext4/mballoc.c: In function 'ext4_exit_mballoc':
> > fs/ext4/mballoc.c:2750: error: implicit declaration of function 'kmem_cache_name'
> > fs/ext4/mballoc.c:2750: warning: cast to pointer from integer of different size
> >
> > Caused by commit 63310467a3d1ed6a0460ec1f4268126cd1ceec2e ("mm: Remove
> > support for kmem_cache_name()").  Clearly the last user has not gone, yet.
> >
> > I have used the version of the slab tree from next-20110121 for today.
>
> Christoph, Ted? Should I revert the patch from slab.git?

Maybe the ext4 patch is not in -next yet?


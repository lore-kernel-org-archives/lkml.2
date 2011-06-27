Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1F0QnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 12:43:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33188 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1F0QnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 12:43:12 -0400
Date: Mon, 27 Jun 2011 17:42:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Dike <jdike@addtoit.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: Tree for June 27 (uml)
Message-ID: <20110627164259.GF11013@ZenIV.linux.org.uk>
References: <20110627161656.688820b9.sfr@canb.auug.org.au>
 <20110627082733.75e58ae4.randy.dunlap@oracle.com>
 <201106271830.43698.richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106271830.43698.richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 06:30:43PM +0200, Richard Weinberger wrote:
> Am Montag 27 Juni 2011, 17:27:33 schrieb Randy Dunlap:
> > On Mon, 27 Jun 2011 16:16:56 +1000 Stephen Rothwell wrote:
> > > Hi all,
> > 
> > > Changes since 20110624:
> > uml defconfig builds on x86 (32-bit and 64-bit) fail with:
> > 
> > fs/hostfs/hostfs_kern.c:756: error: 'mask' undeclared (first use in this
> > function)
> 
> Hmm, "->permission() sanitizing: don't pass flags to ->permission()" is the evil doer.
> Al?

Gyah... s/mask/desired/ in that line.  Will fold...

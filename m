Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab0K1D2i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 22:28:38 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:7006 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266Ab0K1D2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 22:28:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiMEAONZ8Ux5Lcx2gWdsb2JhbACDUJ89FgEBFiIisRePUYEhgzNzBA
Date: Sun, 28 Nov 2010 14:28:30 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Anca Emanuel <anca.emanuel@gmail.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/46] rcu-walk and dcache scaling
Message-ID: <20101128032830.GA12139@amd>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <AANLkTikRDO0C4Giz6vVHeMnHMtOGO5N1gN4wChEwBLpk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikRDO0C4Giz6vVHeMnHMtOGO5N1gN4wChEwBLpk@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 05:04:08PM +0200, Anca Emanuel wrote:
> On Sat, Nov 27, 2010 at 12:15 PM, Nick Piggin <npiggin@kernel.dk> wrote:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git vfs-scale-working
> 
> I get:
>   CC [M]  fs/cifs/inode.o
> fs/cifs/inode.c: In function ‘inode_has_hashed_dentries’:
> fs/cifs/inode.c:807: error: ‘dcache_inode_lock’ undeclared (first use
> in this function)
> fs/cifs/inode.c:807: error: (Each undeclared identifier is reported only once
> fs/cifs/inode.c:807: error: for each function it appears in.)
> make[3]: *** [fs/cifs/inode.o] Error 1
> make[2]: *** [fs/cifs] Error 2
> make[1]: *** [fs] Error 2
> 
> I used the latest mainline.

Sorry, missed a conversion, it just needs to be changed to
inode->i_lock. Pushed the fix to git.

Thanks,
Nick


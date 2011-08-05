Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab1HEEfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 00:35:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab1HEEfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 00:35:19 -0400
Date: Fri, 5 Aug 2011 14:35:09 +1000
From: NeilBrown <neilb@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Josef Bacik <josef@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Subject: [PATCH] Restore 'fsync' functionality on block
 devices.
Message-ID: <20110805143509.33769ce3@notabene.brown>
In-Reply-To: <20110805034859.GQ2203@ZenIV.linux.org.uk>
References: <20110805133456.5aa0c568@notabene.brown>
	<20110805034859.GQ2203@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Aug 2011 04:48:59 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Fri, Aug 05, 2011 at 01:34:56PM +1000, NeilBrown wrote:
> > 
> > Commit 02c24a82187d5a628c68edfe71ae60dc135cd178:
> 
> see da5aa861bea09197e6ae4d7c46618616064891e4 in mainline


http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=da5aa861bea09197e6ae4d7c46618616064891e4

gives me 
  
404 - Unknown commit object 

(as does a 'git show').

But I'll take your word for it that it is on it's way.

Thanks,
NeilBrown


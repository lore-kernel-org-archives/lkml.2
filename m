Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830Ab2LIPEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 10:04:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613Ab2LIPEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 10:04:35 -0500
Date: Sun, 9 Dec 2012 16:04:34 +0100
From: Michal Marek <mmarek@suse.cz>
To: Romain Francoise <romain@orebokech.com>
Cc: Pawel Moll <pawel.moll@arm.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: Do not remove vmlinux when cleaning external
	module
Message-ID: <20121209150434.GB29236@pobox.suse.cz>
References: <1351509782-12462-1-git-send-email-pawel.moll@arm.com> <87fw4hzk9i.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw4hzk9i.fsf@silenus.orebokech.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 01:59:21PM +0100, Romain Francoise wrote:
> Pawel Moll <pawel.moll@arm.com> writes:
> 
> > Since commit 1f2bfbd00e466ff3489b2ca5cc75b1cccd14c123 "kbuild:
> > link of vmlinux moved to a script" make clean with M=<dir>
> > argument (so cleaning external module) removes vmlinux,
> > System.map and couple of other files from the *main* kernel
> > build directory! This not what was happening before and almost
> > certainly not what one would expect.
> 
> > This patch moves makes the clean target of the script called
> > only when !KBUILD_EXTMOD.
> 
> Thanks, I have the same problem and this patch fixes it.
> 
> Michal, can you pick it up? It's not yet in kbuild.git, it seems.

Sorry for the delay. I applied it to kbuild.git#kbuild now, with

Cc: stable@vger.kernel.org [v3.5+]

Michal

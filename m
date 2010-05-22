Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab0EVPv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 11:51:27 -0400
Received: from cobra.newdream.net ([66.33.216.30]:39701 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0EVPv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 11:51:26 -0400
Date: Sat, 22 May 2010 08:54:55 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Greg KH <greg@kroah.com>
cc: Neil Brown <neilb@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Thery <benjamin.thery@bull.net>
Subject: Re: linux-next: build failure after merge of the staging-next tree
In-Reply-To: <20100522144942.GB4269@kroah.com>
Message-ID: <Pine.LNX.4.64.1005220853020.11676@cobra.newdream.net>
References: <20100430155205.a4171034.sfr@canb.auug.org.au>
 <20100430144340.GD1824@kroah.com> <20100518153020.06d5a602@notabene.brown>
 <20100521233655.GD31430@kroah.com> <20100522102048.3923b197@notabene.brown>
 <20100522144942.GB4269@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 May 2010, Greg KH wrote:
> > > Oh, you missed a kref_set() usage in the tree as well, you might want to
> > > fix that up also.
> > 
> > That would be the one in fs/ceph ??
> > Sage knows about that and presumably has a fix queued.
> >   http://lkml.org/lkml/2010/3/17/224
> 
> Ah, yes, I thought I had remembered something about that.

Yep, I just sent off the pull request that includes the kref_set() fix.

sage

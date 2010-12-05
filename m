Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab0LEWk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 17:40:56 -0500
Received: from tundra.namei.org ([65.99.196.166]:38649 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab0LEWkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 17:40:55 -0500
Date: Mon, 6 Dec 2010 09:40:46 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@parisplace.org>
cc: ext-jarkko.2.sakkinen@nokia.com, casey@schaufler-ca.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: VS: [PATCH] Smack: label for task objects (retry 2)
In-Reply-To: <AANLkTikjQuwvD4A0do0RAYheDKFeeXndjtDQvQC2WXEw@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1012060937210.14997@tundra.namei.org>
References: <4CEE4D6E.4030204@nokia.com> <4CF7D16D.4060009@schaufler-ca.com> <alpine.LRH.2.00.1012030823150.25347@tundra.namei.org> <alpine.LRH.2.00.1012030923560.26002@tundra.namei.org> <E3D0B314C5E55043AC59C5FBDB298310EE11A5@008-AM1MPN1-005.mgdnok.nokia.com>
 <AANLkTikjQuwvD4A0do0RAYheDKFeeXndjtDQvQC2WXEw@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Dec 2010, Eric Paris wrote:

> 2) If #1 is true and you want to get Sign-off's in your parent tree
> you can set up the child trees as a remote.  Then you can use:
> 
> git format-patch -k --stdout HEAD..remotes/[child]/[branch] | git am
> -3 -k --whitespace=fix -s

I don't think this is the right approach.  If you're pulling from a repo, 
then your signoff does not go on each patch because you trust the repo.

Otherwise, you should actually be reviewing each patch, which the above is 
not doing.

> Our tree is so simple I don't really understand why we need all this,
> but if we need it, lets figure out what works best for everyone!

Each LSM maintainer should probably be doing per-patch review of the 
patches going into their tree, and adding their signoff, while I will try 
and always just do pulls from those trees.


-- 
James Morris
<jmorris@namei.org>

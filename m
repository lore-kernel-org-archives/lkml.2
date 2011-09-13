Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1IMAn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 20:43:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab1IMAn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 20:43:57 -0400
Date: Tue, 13 Sep 2011 02:43:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Temporary -rcu tree location
In-Reply-To: <20110913002419.GN2362@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1109130242440.13109@pobox.suse.cz>
References: <20110913000107.GA15945@linux.vnet.ibm.com> <alpine.LRH.2.00.1109130210090.19238@twin.jikos.cz> <20110913002419.GN2362@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Sep 2011, Paul E. McKenney wrote:

> Here is what happens when I try that:
> 
> 	git push github :rcu/next
> 	Username: 
> 	Password: 
> 	error: unable to push to unqualified destination: rcu/next
> 	The destination refspec neither matches an existing ref on the remote nor
> 	begins with refs/, and we are unable to guess a prefix based on the source ref.
> 	error: failed to push some refs to 'https://github.com/paulmckrcu/linux'
> 
> So what am I missing here?

Looking at 

	https://github.com/paulmckrcu/linux/branches

there doesn't seem to be 'rcu/next' branch, right?

-- 
Jiri Kosina
SUSE Labs

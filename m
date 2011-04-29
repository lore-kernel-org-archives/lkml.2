Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880Ab1D2Ufr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:35:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37133 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932479Ab1D2Ufo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:35:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the suspend tree with the net tree
Date: Fri, 29 Apr 2011 22:36:19 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
References: <20110429120541.c27998c2.sfr@canb.auug.org.au>
In-Reply-To: <20110429120541.c27998c2.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104292236.19986.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 29, 2011, Stephen Rothwell wrote:
> Hi Rafael,
> 
> Today's linux-next merge of the suspend tree got a conflict in
> arch/x86/Kconfig between commit 0a14842f5a3c ("net: filter: Just In Time
> compiler for x86-64") from the  tree and commit d9f1ce017fcf ("PM: Remove
> sysdev suspend, resume and shutdown operations") from the suspend tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Please do, thanks a lot!

Rafael

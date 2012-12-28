Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2L1Rdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 12:33:55 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60562 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753782Ab2L1Rdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 12:33:53 -0500
Message-ID: <1356716033.31130.10.camel@joe-AO722>
Subject: Re: [PATCH] [trivial]treewide: Fix typo in various drivers
From: Joe Perches <joe@perches.com>
To: Anders Larsen <al@alarsen.net>
Cc: Masanari Iida <standby24x7@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Dec 2012 09:33:53 -0800
In-Reply-To: <1356712748.4121.5@oscar>
References: <1356709778-6933-1-git-send-email-standby24x7@gmail.com>
	 <1356712748.4121.5@oscar>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-28 at 17:39 +0100, Anders Larsen wrote:
> On 2012-12-28 16:49, Masanari Iida wrote:
> > Correct spelling typo in printk within various drivers.
> > ---
> > diff --git a/net/caif/cfcnfg.c b/net/caif/cfcnfg.c
[]
> > @@ -402,7 +402,7 @@ cfcnfg_linkup_rsp(struct cflayer *layer, u8  
> > channel_id, enum cfctrl_srv serv,
> > 
> >  	phyinfo = cfcnfg_get_phyinfo_rcu(cnfg, phyid);
> >  	if (phyinfo == NULL) {
> > -		pr_err("ERROR: Link Layer Device dissapeared"
> > +		pr_err("ERROR: Link Layer Device dissappeared"
> 
> that should rather be
> +		pr_err("ERROR: Link Layer Device disappeared"
> 
> >  				"while connecting\n");

Instead use:

		pr_err("ERROR: Link Layer Device disappeared while connecting\n");

so there a space between before while
and it's easier to grep

Because it's already pr_err, I think the
"ERROR: " prefix doesn't have any added
value either.


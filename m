Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177Ab2GMM3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 08:29:14 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:38923 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653Ab2GMM3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 08:29:12 -0400
Date: Fri, 13 Jul 2012 08:29:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 13
Message-ID: <20120713122910.GA17109@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20120713155121.6adf5468fdc72ad72dabb403@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713155121.6adf5468fdc72ad72dabb403@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 03:51:21PM +1000, Stephen Rothwell wrote:
> 
> The ext4 tree still has its build failure so I used the version from
> next-20120709.

I fixed this last night, but I probably just missed when you pulled in
the ext4 tree.  So hopefully you should have no problems with your
next linux-next build.

						- Ted

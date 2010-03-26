Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0CZQEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 12:04:05 -0400
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:38921 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752259Ab0CZQEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 12:04:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bMCuzLCIS4ugS/hFRh9PCy3O/VlNLhsMAwdQ9/Ihx+QWn6zDDdD+Jez6sMN4P8dJb4w7XRlE1wVXvOnc+16G92EZbdOBBYeNmXvEsF6QkFRblLVk7swmQIsJkgP3wEbV;
Date: Fri, 26 Mar 2010 09:03:20 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: linux-next: manual merge of the pci tree with the pci-current
 tree
Message-ID: <20100326090320.0764979a@jbarnes-piketon>
In-Reply-To: <20100326134836.ebe45694.sfr@canb.auug.org.au>
References: <20100326115712.2d800053.sfr@canb.auug.org.au>
	<20100325191049.18020272@jbarnes-piketon>
	<20100326134836.ebe45694.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010 13:48:36 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jesse,
> 
> On Thu, 25 Mar 2010 19:10:49 -0700 Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >
> > Time to rebase my -next branch onto my for-linus branch again I guess.
> 
> Any reason you wouldn't just merge your for-linus branch into your -next branch?

I don't like to end up with a bunch of merges, so I generally just
rebase my -next branch as necessary.

-- 
Jesse Barnes, Intel Open Source Technology Center

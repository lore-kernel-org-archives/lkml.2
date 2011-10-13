Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab1JMD5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 23:57:19 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44681 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab1JMD5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 23:57:18 -0400
Date: Wed, 12 Oct 2011 21:57:14 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the gpio tree
Message-ID: <20111013035714.GD15829@ponder.secretlab.ca>
References: <20111006144826.a69a5ea59d4ca94f8f7414cf@canb.auug.org.au>
 <20111011173714.d54bbcee6c0676ddcc37a1f3@canb.auug.org.au>
 <4E93EA10.4030405@dsn.lapis-semi.com>
 <20111012152451.66ce5ddffb4c5b3a4f6a31cf@canb.auug.org.au>
 <4E9525AC.9080909@dsn.lapis-semi.com>
 <CABMQnV+S2WbW0YZBiMXfs81b2dyLzj9wBxPmNuFrYErKfXsWtg@mail.gmail.com>
 <4E9551B8.4060601@dsn.lapis-semi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9551B8.4060601@dsn.lapis-semi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 05:37:12PM +0900, Tomoya MORINAGA wrote:
> (2011/10/12 16:21), Nobuhiro Iwamatsu wrote:
> >This is a problem of generic-chip.
> >I created the patch and contributed the point to LKML.
> >He forgot to put you into CC, sorry.
> >
> >Please check LKML for subject of "[PATCH] irq: Add EXPORT_SYMBOL to
> >function of irq generic-chip".
> >
> 
> OK,
> We will be able to use our GPIO driver with module soon.
> Good information.

I've temporarily pushed out a commit that makes the pch and ml_ioh
bool instead of tristate.  If that other patch gets acked by Thomas,
then I should probably take it through the gpio tree.

g.


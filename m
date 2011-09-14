Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab1INOuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 10:50:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684Ab1INOun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 10:50:43 -0400
Date: Wed, 14 Sep 2011 16:50:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Temporary location for hid, apm and trivial trees
In-Reply-To: <20110915000759.44ec63c0f9a3d68239886de5@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1109141650280.13109@pobox.suse.cz>
References: <alpine.LNX.2.00.1109141520450.13109@pobox.suse.cz> <20110915000759.44ec63c0f9a3d68239886de5@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011, Stephen Rothwell wrote:

> > temporary locations for hid, apm and trivial trees until kernel.org 
> > reappears, are
> > 
> > 	git://twin.jikos.cz/jikos/hid
> > 	git://twin.jikos.cz/jikos/apm
> > 	git://twin.jikos.cz/jikos/trivial
> 
> I am assuming the for-next branch of each.  However, fetching the trivial
> tree fails with:
> 
> fatal: The remote end hung up unexpectedly
> 
> I will switch to these tomorrow (assuming that you fix the trivial tree).

Ah, you are right, it has been broken. Fixed now.

Thanks,

-- 
Jiri Kosina
SUSE Labs

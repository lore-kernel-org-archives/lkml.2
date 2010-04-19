Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab0DSUMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 16:12:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:49166 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab0DSUML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 16:12:11 -0400
Date: Mon, 19 Apr 2010 22:12:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Tejun Heo <tj@kernel.org>, Jeff Dike <jdike@addtoit.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net,
       Tiger Yang <tiger.yang@oracle.com>
Subject: Re: [PATCH] uml: Fix build breakage after slab.h changes
In-Reply-To: <4BCCB89C.50201@web.de>
Message-ID: <alpine.LNX.2.00.1004192211140.7579@pobox.suse.cz>
References: <4BCB353A.3040806@web.de> <4BCB788E.2040501@kernel.org> <4BCC07C0.5050601@web.de> <alpine.LRH.2.00.1004191829220.28179@twin.jikos.cz> <4BCCB89C.50201@web.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010, Jan Kiszka wrote:

> >>> I suppose this patch will go through um tree?
> >> Good question. Does such a tree exist? I'm sitting on a few more um
> >> cleanups & fixes, and so far I'm working against Linus' tree as I failed
> >> to find anything more recent.
> > 
> > If these are simple-enough cleanups and/or compile fixes, feel free to 
> > send them to trivial@kernel.org.
> > 
> Some are trivial, but most aren't. Will check if I can split the formers
> out, but I guess it's simpler to keep the queue.

Well, if Jeff isn't actively maintaining UML any more, either you can take 
over the maintainership yourself, or feed the non-trivial patches through 
Andrew Morton.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

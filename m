Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab2BXW5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:57:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756925Ab2BXW5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:57:35 -0500
Date: Fri, 24 Feb 2012 23:51:22 +0100
From: Michal Marek <mmarek@suse.cz>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Greg Dietsche <Gregory.Dietsche@cuw.edu>, julia.lawall@lip6.fr,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coccicheck: change handling of C={1,2} when M= is set
Message-ID: <20120224225122.GA19992@sepie.suse.cz>
References: <4F1928FC.8090300@inria.fr>
 <1327101035-7684-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <1327101035-7684-2-git-send-email-Gregory.Dietsche@cuw.edu>
 <4F1A6AC1.70300@inria.fr>
 <4F45093B.3030802@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F45093B.3030802@inria.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 04:26:51PM +0100, Brice Goglin wrote:
> Unless I missed something, this fix still has not been applied in 3.3-rc.
> Brice
> 
> 
> 
> Le 21/01/2012 08:35, Brice Goglin a écrit :
> > Thanks a lot Greg, make C=2 CHECK=script/coccicheck M=... is back.
> >
> > Tested-by: Brice Goglin <Brice.Goglin@inria.fr>

I applied it to kbuild.git#rc-fixes now.

Michal

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab0F2MO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:14:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:47537 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab0F2MO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:14:58 -0400
Date: Tue, 29 Jun 2010 14:14:57 +0200
From: Michal Marek <mmarek@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2] Makefile: fix missing dash when using make
 LOCALVERSION=xxx
Message-ID: <20100629121457.GB13335@sepie.suse.cz>
References: <20100628030507.5187.95903.sendpatchset@localhost.localdomain>
 <alpine.DEB.2.00.1006280207580.28072@chino.kir.corp.google.com>
 <4C286A8F.9080508@redhat.com>
 <alpine.DEB.2.00.1006281145590.25490@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1006281145590.25490@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 11:46:37AM -0700, David Rientjes wrote:
> On Mon, 28 Jun 2010, Cong Wang wrote:
> 
> > But in your patch description, you said:
> > 
> >     Without CONFIG_LOCALVERSION_AUTO, "make" results in v2.6.32-rc4+
> >     unless the repository is at the Linux v2.6.32-rc4 commit (in which
> >     case the version would be v2.6.32-rc4).  If "make LOCALVERSION=kbuild"
> >     were used, it results in v2.6.32-rc4-kbuild.
> > 
> > So, shouldn't that be "make LOCALVERSION=-kbuild"?
> > 
> 
> Yup, that's what it should have said.  That doesn't mean that we need to 
> change the long-standing behavior of LOCALVERSION= to add an implied `-', 
> though.

Agreed, we should not enforce any new policy here. Someone might wish to
use underscores as separators for instance.

Michal

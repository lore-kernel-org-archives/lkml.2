Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2JSHev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 03:34:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706Ab2JSHeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 03:34:50 -0400
Date: Fri, 19 Oct 2012 09:34:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefani Seibold <stefani@seibold.net>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove untouched code in kfifo_in
In-Reply-To: <1350624189.14741.1.camel@wall-e>
Message-ID: <alpine.LNX.2.00.1210190934010.7523@pobox.suse.cz>
References: <1350568765-5723-1-git-send-email-weiyang@linux.vnet.ibm.com>  <CAFLxGvwfGc_4z1JM=pAb-U4tNVeMZR1zs-neQv7Vz2-6DQT+9Q@mail.gmail.com> <1350624189.14741.1.camel@wall-e>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012, Stefani Seibold wrote:

> > > In kfifo_in marco, one piece of code is arounded by if(0). This code in
> > > introduced by Stefani Seibold <stefani@seibold.net> to suppress a compiler
> > > warning. This warning is not there with the upgrade of gcc version.
> > >
> > > This patch just remove this code.
> > 
> > Are you sure?
> > This code fragment looks like a compiler bomb to detect type mismatch to me...
> 
> Yes, you are great! That was the reason why i made this peace of code.
> So don't remove it!

As even you, the author of the code, got confused by it for a while, 
adding an explanatory comment seems appropriate.

Thanks,

-- 
Jiri Kosina
SUSE Labs

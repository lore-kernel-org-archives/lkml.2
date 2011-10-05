Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab1JEHyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:54:44 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:46104 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab1JEHyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:54:43 -0400
Date: Wed, 5 Oct 2011 10:54:39 +0300
From: Adrian Bunk <bunk@stusta.de>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111005075438.GA29441@localhost.pp.htv.fi>
References: <201110020304.28288.rjw@sisk.pl>
 <4E87B885.50005@zytor.com>
 <201110021354.57995.rjw@sisk.pl>
 <4E88A537.4010008@zytor.com>
 <20111003093239.GB25136@localhost.pp.htv.fi>
 <y0mobxyjazi.fsf@fche.csb>
 <20111003180441.GD3072@localhost.pp.htv.fi>
 <34045.1317760188@turing-police.cc.vt.edu>
 <20111004223932.GA3460@localhost.pp.htv.fi>
 <20111004231730.GB17089@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111004231730.GB17089@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 07:17:30PM -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Wed, Oct 05, 2011 at 01:39:32AM +0300, Adrian Bunk wrote:
> 
> > [...]  But the semantics of PGP key signing is that you certify that
> > you verified that a photo ID of that person matches the name on the
> > key.  [...]
> 
> But that's begging the question.  The semantics are what you want them
> to be.  Some keysigning parties take this super seriously, and maybe
> with strangers there's some room for this.  But in the end, when *I*
> see a key with someone else's signature on it, there is no proof how
> rigorously they investigated the person.  The "reliable identity" part
> of the web of trust is only one hop deep.

That is a rigid policy, but not the only one.

And it has practical limitations - "Key must be signed
by H. Peter Anvin" might be a consequence for kernel.org.

What policy is now used at kernel.org now is exactly the question
I asked in [1], and where I'm still waiting for an answer from hpa.

Other organizations like Debian have a clear and public policy on 
what is required for the user identification part for uploading to
the archive [2], and I expect the same for kernel.org.

> - FChE

cu
Adrian

[1] https://lkml.org/lkml/2011/10/3/362
[2] http://www.debian.org/devel/join/nm-step2

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


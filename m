Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab1EaGqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 02:46:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757947Ab1EaGqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 02:46:12 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: david@lang.hm
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
Date: Tue, 31 May 2011 08:48:14 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "D. Jansen" <d.g.jansen@googlemail.com>, Theodore Tso <tytso@mit.edu>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com> <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105310848.15148.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 30. Mai 2011, 20:45:42 schrieb david@lang.hm:
> > The big problem is that so far only fsync existed and lots of software
> > seemingly abuses it as an expensive write barrier. And it would really
> > be lovely to have the choice to stop that on an opt-in basis in laptop
> > mode.
> 
> is the benifit of not spinning up the disk really worth the risk of 
> loosing data?

That is a policy question.

> and should this really be a global across-the-board option?

Possibly not. However this is a secondary question.

> the problem is that most users don't know what their system is running, or 
> what effect disaling fsync would have. those that do can probably use 
> LD_PRELOAD to override fsync calls.

Not without a loss of ordering, as we have discussed.

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 

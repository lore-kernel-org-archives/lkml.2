Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab0FAGxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 02:53:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38142 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab0FAGxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 02:53:46 -0400
Date: Tue, 1 Jun 2010 08:53:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Alexander Viro <viro@ftp.linux.org.uk>
Cc: tytso@mit.edu, Alex Buell <alex.buell@munted.org.uk>,
       Mailing Lists - Kernel Developers 
	<linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Article in Phoronix about loss of performance in 2.6.35 release
 candidates
Message-ID: <20100601065311.GA7430@elte.hu>
References: <1275347969.29006.5.camel@lithium.local.net>
 <20100601041028.GB4426@thunk.org>
 <AANLkTikRoff0zK-o8W4Wb_MveGibxlOG8mnrQMBtYZOY@mail.gmail.com>
 <20100601061749.GA26705@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601061749.GA26705@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

>  - it has no link back to '3836a03: anon_inodes: mark the anon inode private' 
>    which introduced it and hence it has no -stable tag either.

Ah, it got introduced by a7cf4145bb86 so no -stable relevancy.

	Ingo

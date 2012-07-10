Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2GJFMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 01:12:34 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48410 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751689Ab2GJFMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 01:12:33 -0400
Message-ID: <1341897152.6118.116.camel@joe2Laptop>
Subject: Re: +
 checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch added to
 -mm tree
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        apw@canonical.com
Date: Mon, 09 Jul 2012 22:12:32 -0700
In-Reply-To: <alpine.DEB.2.00.1207091904480.25143@chino.kir.corp.google.com>
References: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com>
	 <alpine.DEB.2.00.1207091514310.32082@chino.kir.corp.google.com>
	 <1341873376.6118.56.camel@joe2Laptop>
	 <alpine.DEB.2.00.1207091553120.3552@chino.kir.corp.google.com>
	 <1341876067.6118.67.camel@joe2Laptop>
	 <alpine.DEB.2.00.1207091640170.8185@chino.kir.corp.google.com>
	 <1341881721.6118.92.camel@joe2Laptop>
	 <alpine.DEB.2.00.1207091834230.20591@chino.kir.corp.google.com>
	 <1341885802.6118.101.camel@joe2Laptop>
	 <alpine.DEB.2.00.1207091904480.25143@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 19:21 -0700, David Rientjes wrote:
> On Mon, 9 Jul 2012, Joe Perches wrote:
> 
> > I don't really care what style a large block of code
> > uses.  I care that it mostly has the same form.

> Same form??  The sizeof operator has two forms depending on whether it's a 
> unary expression or a type as specified by the standard.

> The issue here is that you're mandating they all use the same form because 
> you're quoting an email from Linus four years ago that you dug up but 
> isn't required in the coding style and is already used in over 1000 places 
> in the kernel.

$ git grep -E "\bsizeof\s*\*"|wc -l
935
$ git grep -E "\bsizeof\s*\(\s*\*"|wc -l
12762

> If you want the output of checkpatch.pl to be useful, I would think you 
> would want to eliminate this kind of garbage.

You are using high emotion words for little purpose.

checkpatch is useful, but it's not all that useful for those
quite familiar with kernel style.

Except maybe to generate flame emails...

It does have some use for reviewing patches.

> > "Another example of this is "sizeof". The kernel universally (I hope) has 
> > parenthesis around the sizeof argument, even though it's clearly not 
> > required by the C language."
> 
> He's obviously addressing a single form of the sizeof operator, i.e. those 
> on unary expressions; sizeof used on a type CLEARLY DOES require the 
> parenthesis.

That's one opinion, though I doubt it's his.
<shrug>  Maybe he'll reply.  (edit: he did)

> you're talking purely about style preferences here.

_All_ of checkpatch is style preference.
None if it is a mandate.  Those that care to use it can.
You can ignore it.  I don't mind.

Otherwise, just read and write the code and do what you
think best.  I'm not a particular style zealot.  I'm not
going to nack a patch just because you or anyone else uses
a style that isn't the predominate one.

cheers, Joe


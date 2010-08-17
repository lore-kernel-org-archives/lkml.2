Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab0HQQBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:01:35 -0400
Received: from adelie.canonical.com ([91.189.90.139]:38099 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab0HQQBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:01:31 -0400
Date: Tue, 17 Aug 2010 17:01:23 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Sylvestre Ledru <sylvestre.ledru@scilab.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walker <dwalker@fifo99.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Usage of checkpatch.pl for other projects
Message-ID: <20100817160123.GL6193@shadowen.org>
References: <1269337074.12129.4674.camel@korcula.inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269337074.12129.4674.camel@korcula.inria.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 10:37:54AM +0100, Sylvestre Ledru wrote:
> Hello,
> 
> I saw the very interesting presentation of Greg at the last FOSDEM where
> he explained how to write a patch of the kernel. 
> 
> During his presentation, he presented the script checkpatch.pl which
> checks the coding style of a patch / file. 
> 
> For a while, I have been looking for such script which can check the
> compliance of a source code against a coding policy.
> 
> Obviously, the coding style of my project is not exactly the same as he
> Kernel one. 
> 
> Therefor, I would like to know if there is any plan of making a
> dedicated project of this piece of software to allow usage of it for
> other projects.
> If it is not the case, is it possible to contribute to change the
> behavior of the policy check (of course, disable by default for kernel
> hackers) ?

An interesting question.  Cirtianly most of its behaviour is kernel
centric.  The source kinda lives outside the kernel with its tests
so could be consumed by other projects (though we do keep a copy in the
kernel tree too).  If changes could be conditional on the project I
could see it being possible.  What sort of differences are you thinking
about.

-apw

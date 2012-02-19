Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab2BSXJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 18:09:37 -0500
Received: from ozlabs.org ([203.10.76.45]:40274 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab2BSXJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 18:09:36 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/12] arch/powerpc: remove references to cpu_*_map.
In-Reply-To: <1329362944.3772.45.camel@pasglop>
References: <1329281884.20466.rusty@rustcorp.com.au> <4F3B790F.1040907@linux.vnet.ibm.com> <1329362944.3772.45.camel@pasglop>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 20 Feb 2012 09:15:03 +1030
Message-ID: <87pqda8mts.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012 14:29:04 +1100, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Wed, 2012-02-15 at 14:51 +0530, Srivatsa S. Bhat wrote:
> > On 02/15/2012 10:28 AM, Rusty Russell wrote:
> > 
> > > From: Rusty Russell <rusty@rustcorp.com.au>
> > > 
> > > This has been obsolescent for a while; time for the final push.
> > > 
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> Want me to stick that in -powerpc ? If yes, now or -next ?

Please, in -next.

Cheers,
Rusty.

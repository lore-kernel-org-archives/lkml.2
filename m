Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab1JQQWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:22:20 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:34450 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818Ab1JQQWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:22:18 -0400
X-Sasl-enc: u+Pjq7btrDOUnbHjYgIAgfz7pFoqazC607f6EnKk5gbK 1318868537
Date: Mon, 17 Oct 2011 09:22:08 -0700
From: Greg KH <greg@kroah.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        herbert@gondor.hengli.com.au
Subject: Re: [PATCH v2.1 1/7] crypto: GnuPG based MPI lib - source files
 (part 1)
Message-ID: <20111017162208.GA6661@kroah.com>
References: <cover.1318598705.git.dmitry.kasatkin@intel.com>
 <92d93a9fe52e048a21d19732c31d80c9ec44de77.1318598705.git.dmitry.kasatkin@intel.com>
 <alpine.LRH.2.00.1110151125280.24994@tundra.namei.org>
 <CALLzPKZ63vp9W_p1t1JOCui+aLRyN6W0t9O-tJ40xKxBef0QPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKZ63vp9W_p1t1JOCui+aLRyN6W0t9O-tJ40xKxBef0QPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 12:11:37PM +0300, Kasatkin, Dmitry wrote:
> >From Kernel Docbook
> 
>     Similar to <function>EXPORT_SYMBOL()</function> except that the
>     symbols exported by <function>EXPORT_SYMBOL_GPL()</function> can
>     only be seen by modules with a
>     <function>MODULE_LICENSE()</function> that specifies a GPL
>     compatible license.  It implies that the function is considered
>     an internal implementation issue, and not really an interface.
> 
> "not really an interface"....
> 
> Should it really be EXPORT_SYMBOL_GPL?

Yes.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab1LBAE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 19:04:57 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45692 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755746Ab1LBAE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 19:04:56 -0500
X-Sasl-enc: n2tRQXSjguUIn8NSnEbC9WFlIMSJIpcyFsQGkcXSXzne 1322784295
Date: Thu, 1 Dec 2011 16:03:50 -0800
From: Greg KH <greg@kroah.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, rusty@ozlabs.org, siglesia@cern.ch,
        manohar.vanga@cern.ch, dave.martin@linaro.org
Subject: Re: [RFC PATCH V2 0/1] making order in file2alias
Message-ID: <20111202000350.GA6507@kroah.com>
References: <cover.1322781825.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1322781825.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 12:45:25AM +0100, Alessandro Rubini wrote:
> (this message is the RFC, the patch itself is expected to be fine)
> 
> This is a repost of what I've sent on Nov 4th.  Since Rusty asked to
> only do the first step, here it is.  I rebased on next-20111201 and it
> still works fine.

Well, some of us disagree with Rusty :)

As he's still the maintainer of the module code, I'll defer to him
though.

> As for the previous 2/2 (see https://lkml.org/lkml/2011/11/4/127 ),
> I still think it makes sense. And as Dave Martin suggested, we can
> do without the array.
> 
> Thus, I may prepare three smaller steps, if that's acceptable (greg?)
> 
>   step 1: create the ELF section so ENTRY() lines can leave the array
>           (and change name accordingly).
> 
>   step 2: each ENTRY() line can be moved just after the associated code
>           (this means that a new bus is just a single hunk, not 2 of them)
> 
>   step 3: I create the headers needed to move code and ENTRY in separate
>           files. This is some movement around, not trivial so it may
>           deserve a patch in itself.
> 
>   step 4 and later ones: Individual busses may reach their own external file,
>          conditionally compiled per Kconfig rules.
> 
> If that's something worth evaluating, I can do that over the weekend.

That sounds very reasonable to me.

thanks,

greg k-h

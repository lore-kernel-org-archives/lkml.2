Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1HXW6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:58:07 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37203 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751Ab1HXW6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:58:05 -0400
X-Sasl-enc: dTpn4N9xyZfrE5qTXdNvwVSTqfiv/VJBGeEKRmy88a4t 1314226684
Date: Wed, 24 Aug 2011 15:57:58 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        edwin_rong <edwin_rong@realsil.com.cn>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20110824225758.GA3454@kroah.com>
References: <20110824154741.3cbe03b403b646e2a99d63a2@canb.auug.org.au>
 <20110824211646.GB9707@kroah.com>
 <20110825085420.521cc24fddadc7753dc67199@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825085420.521cc24fddadc7753dc67199@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 08:54:20AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Wed, 24 Aug 2011 14:16:46 -0700 Greg KH <greg@kroah.com> wrote:
> >
> > To fix it, all we have to do is include linux/vmalloc.h, right?  Or is
> 
> I would assume so.
> 
> > ppc "special" in some other way regarding this call?
> 
> I assume it happens just because vmalloc.h is implicitly included by some
> other header file on x86 and not on ppc.
> 
> This is why we have "Rule 1" in Documentation/SubmitChecklist.  Relying
> on the implicit inclusion of header files is bound to trip us up on some
> architecture or platform or combination of CONFIG options.

Fair enough, I've made this fix in my tree, so it should be good now.

thanks,

greg k-h

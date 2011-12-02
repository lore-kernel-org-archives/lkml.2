Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1LBTbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:31:00 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58193 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754005Ab1LBTa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:30:58 -0500
X-Sasl-enc: w/uRG9zObMD/98xSkHCFGtO7uyB0OhjidpSFZGeBcFjT 1322854257
Date: Fri, 2 Dec 2011 11:27:01 -0800
From: Greg KH <greg@kroah.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: rusty@ozlabs.org, linux-kernel@vger.kernel.org, siglesia@cern.ch,
        manohar.vanga@cern.ch, dave.martin@linaro.org
Subject: Re: [RFC PATCH V2 0/1] making order in file2alias
Message-ID: <20111202192701.GB13860@kroah.com>
References: <87pqg7r8q9.fsf@rustcorp.com.au>
 <cover.1322781825.git.rubini@gnudd.com>
 <20111202000350.GA6507@kroah.com>
 <20111202084213.GA3415@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111202084213.GA3415@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 09:42:13AM +0100, Alessandro Rubini wrote:
> > But splitting 15-line functions into separate files?  Less compact, less
> > simple.
> 
> Personally, I'm more interested in the addition of new busses (as
> drop-in files) than the split up of current ones. But I see your point.

Yes, that's what me and Linus have asked about having in the past,
making things easier to merge and the like.  Now admittedly, this file
isn't all that hard to merge these days given that the addition of new
busses is pretty rare, these complaints might have been from before git
times, when merges were harder than they are now.

Anyway, I like your patch as well, as it seems to get us to that goal.

thanks,

greg k-h

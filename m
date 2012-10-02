Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2JBN7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:59:12 -0400
Received: from 1wt.eu ([62.212.114.60]:35820 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab2JBN7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:59:10 -0400
Date: Tue, 2 Oct 2012 15:59:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Roger Blofeld <blofeldus@yahoo.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 099/180] powerpc/ftrace: Fix assembly trampoline register usage
Message-ID: <20121002135905.GA32113@1wt.eu>
References: <20121001225201.807308843@1wt.eu> <506AEFEC.5010304@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506AEFEC.5010304@windriver.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 09:45:16AM -0400, Paul Gortmaker wrote:
> On 12-10-01 06:53 PM, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: roger blofeld <blofeldus@yahoo.com>
> > 
> > commit fd5a42980e1cf327b7240adf5e7b51ea41c23437 upstream.
> > 
> > Just like the module loader, ftrace needs to be updated to use r12
> > instead of r11 with newer gcc's.
> > 
> > Signed-off-by: Roger Blofeld <blofeldus@yahoo.com>
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > commit a8ed5765b5a8bf44a86284d80afd24f37a23e369 upstream.
> 
> Not sure what the above is -- cut and paste misstep?
> The fd5a429 at the top is the correct parent though.

Oops, you're right Paul, it's the commit ID from the 3.0 branch I picked
it from. Just removed it now.

Thanks,
Willy


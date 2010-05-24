Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab0EXX0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:26:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:35561 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932826Ab0EXX0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:26:10 -0400
Date: Mon, 24 May 2010 16:25:24 -0700
From: Greg KH <gregkh@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Frank Arnold <frank.arnold@amd.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [20/34] x86, cacheinfo: Turn off L3 cache index disable
 feature in virtualized environments
Message-ID: <20100524232524.GA18124@suse.de>
References: <20100524230351.136502585@clark.site>
 <4BFB080F.3080508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFB080F.3080508@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 04:13:19PM -0700, H. Peter Anvin wrote:
> On 05/24/2010 03:59 PM, Greg KH wrote:
> > 2.6.34-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Frank Arnold <frank.arnold@amd.com>
> > 
> > commit 7f284d3cc96e02468a42e045f77af11e5ff8b095 upstream.
> > 
> 
> Objection only that this already in 2.6.34.

Of course it is, I stupidly said ".34" when this is a ".32" review
cycle.

Same thing for all of the patches in this series, sorry, my bad.

/me goes off to kick his scripts into submission...

greg k-h

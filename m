Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1AGTTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:19:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab1AGTTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:19:41 -0500
Date: Fri, 7 Jan 2011 11:19:30 -0800
From: Greg KH <gregkh@suse.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Nelson Elhage <nelhage@ksplice.com>,
        "David S. Miller" <davem@davemloft.net>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [069/152] econet: Do the correct cleanup after an
 unprivileged SIOCSIFADDR.
Message-ID: <20110107191930.GB16084@suse.de>
References: <20110106002500.GA3172@kroah.com>
 <20110106002303.148373791@clark.site>
 <20110107191036.GG32717@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107191036.GG32717@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 02:10:36PM -0500, Paul Gortmaker wrote:
> [[stable] [069/152] econet: Do the correct cleanup after an unprivileged SIOCSIFADDR.] On 05/01/2011 (Wed 16:22) Greg KH wrote:
> 
> > 2.6.36-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > 
> > From: Nelson Elhage <nelhage@ksplice.com>
> > 
> > [ Upstream commit f24b8bedf70c524775eabd51570c3fa7708a97b7 ]
> 
> I think the upstream # got mangled somehow.  Looking at the tree, I
> think the upstream is 0c62fc6dd02c8d793c75ae76a9b6881fc36388ad.
> 
> The ID listed currently gives me a "bad object". 

Nice catch, I don't know what happened here, must be something in
David's scripts, not mine :)

I'll go edit the changelog before I commit it later today, thanks.

greg k-h

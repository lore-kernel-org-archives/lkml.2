Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2LMLX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:23:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab2LMLX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:23:26 -0500
Date: Thu, 13 Dec 2012 11:23:23 +0000
From: Mel Gorman <mgorman@suse.de>
To: anish kumar <anish198519851985@gmail.com>
Cc: Han Pingtian <hanpt@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: A typo about kernelcore= ?
Message-ID: <20121213112323.GB9887@suse.de>
References: <20121207070241.GA2464@localhost.localdomain>
 <1354949336.22178.4.camel@anish-Inspiron-N5050>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1354949336.22178.4.camel@anish-Inspiron-N5050>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 10:48:56PM -0800, anish kumar wrote:
> On Fri, 2012-12-07 at 15:02 +0800, Han Pingtian wrote:
> > Hi there,
> > 
> > I'm wondering this is a typo in Documentation/kernel-parameters.txt
> > about "kernelcore=":
> >     
> >     .... In the event, a node is too small to have both
> >     kernelcore and Movable pages, kernelcore pages will
> >     take priority and other nodes will have a larger number
> >     of kernelcore pages.
> > 
> > I think it should be 
> > 
> >     .... In the event, a node is too small to have both
> >     kernelcore and Movable pages, kernelcore pages will
> >     take priority and other nodes will have a larger number
> >     of *Movable* pages.
> > 
> > Is it right? Thanks in advance!
> adding the maintainer.

yeah, larger number of movable pages

-- 
Mel Gorman
SUSE Labs

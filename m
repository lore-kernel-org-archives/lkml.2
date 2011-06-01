Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab1FAW4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:56:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:45535 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab1FAW4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:56:53 -0400
Date: Thu, 2 Jun 2011 07:57:23 +0900
From: Greg KH <gregkh@suse.de>
To: Bryan Hundven <bryanhundven@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Long-term stable versions in linux-2.6-stable.git?
Message-ID: <20110601225723.GA18471@suse.de>
References: <BANLkTi=6-sGL9QJbyK34kCPbaPVOREE1QA@mail.gmail.com>
 <20110601211506.GA16121@suse.de>
 <BANLkTi=MF2ApN4yRvFOr2sM3PbrnRGPtng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=MF2ApN4yRvFOr2sM3PbrnRGPtng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 03:33:21PM -0700, Bryan Hundven wrote:
> On Wed, Jun 1, 2011 at 2:15 PM, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Jun 01, 2011 at 10:38:35AM -0700, Bryan Hundven wrote:
> >> Hello,
> >>
> >> I was wondering if there are plans to include the long-term stable
> >> versions in the /pub/scm/linux/kernel/git/stable/linux-2.6-stable.git
> >> repository?
> >>
> >> I'm not subscribed to lkml, please cc on response.
> >
> > It's been discussed numerous times in the past, the thing is, I don't
> > control the script that does this so I have no control over it, sorry.
> 
> Ok. The reason I ask is that it is painful to merge changes from
> 2.6.35.13 back to 2.6.35.9, then forward to >2.6.36, although I guess
> I will have to live with it.

Why would you have to do that?  Why can't you just create the tree
yourself by pulling from the different longterm branches?

> If you don't mind me asking; who controls the script that does this?

I really don't know, sorry.

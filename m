Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab2DKSH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:07:58 -0400
Received: from fifo99.com ([67.223.236.141]:57212 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753Ab2DKSH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:07:57 -0400
Date: Wed, 11 Apr 2012 11:07:55 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: David Brown <davidb@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: msm: remove unused MSM boards
Message-ID: <20120411180754.GD8114@fifo99.com>
References: <1334165870-12487-1-git-send-email-davidb@codeaurora.org>
 <20120411175550.GB8114@fifo99.com>
 <20120411180408.GA12930@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411180408.GA12930@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 11:04:09AM -0700, David Brown wrote:
> On Wed, Apr 11, 2012 at 10:55:50AM -0700, Daniel Walker wrote:
> > On Wed, Apr 11, 2012 at 10:37:50AM -0700, David Brown wrote:
> > > The "mahimahi" and "sapphire" were never finished, and have never been
> > > built.
> > > 
> > > The "halibut" target was a dev board that hasn't ever been widely
> > > available (MSM7201 "SURF").
> > 
> > I don't mind if you remove halibut, but the others are just incomplete
> > phone support which someone may want to add to.. I'd prefer to fix those
> > two..
> 
> Why, though?  It's obvious that nobody is using them, since they've
> never worked.

Didn't I submit patches to make mahimahi build, and boot? So someone has
at least used mahimahi ..

Daniel

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0LAODh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:03:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36045 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab0LAODg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:03:36 -0500
Date: Wed, 1 Dec 2010 15:03:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Randy Dunlap <rdunlap@xenotime.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] add netdev led trigger
Message-ID: <20101201140330.GA7218@basil.fritz.box>
References: <1290998056-8310-1-git-send-email-ecc@cmu.edu>
 <87ipzgl9k8.fsf@basil.nowhere.org>
 <20101201000300.GJ21496@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201000300.GJ21496@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 07:03:00PM -0500, Eric Cooper wrote:
> On Mon, Nov 29, 2010 at 11:15:51AM +0100, Andi Kleen wrote:
> > Using the device name as an identifier is not reliable, they may not
> > be unique.
> 
> I'm confused about this -- how else can the user specify the desired network
> interface?

For presenting the user the name is probably still the best, but internally
better use the interface index.
> 
> > rwlocks are deprecated.
> 
> In favor of what?  Should I use a spinlock?

spinlocks or mutexes.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1BXX1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 18:27:07 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:58703 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab1BXX1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 18:27:05 -0500
Date: Thu, 24 Feb 2011 15:27:00 -0800
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: dsd@laptop.org, sparclinux@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v5] of/promtree: allow DT device matching by fixing
 'name' brokenness
Message-ID: <20110224152700.5663b8e7@queued.net>
In-Reply-To: <20110224194234.GA8907@angua.secretlab.ca>
References: <20110224165917.3760.24493.stgit@localhost6.localdomain6>
	<20110224093341.5a809a13@queued.net>
	<20110224194234.GA8907@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011 12:42:34 -0700
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Thu, Feb 24, 2011 at 09:33:41AM -0800, Andres Salomon wrote:
> > On Thu, 24 Feb 2011 10:04:41 -0700
> > Grant Likely <grant.likely@secretlab.ca> wrote:
> > 
> > > From: Andres Salomon <dilinger@queued.net>
> > > 
[...]
> I've pushed the latest version out to my devicetree/experimental
> branch on git://git.secretlab.ca/git/linux-2.6.  Give it a spin and
> make sure everything is still working for you.
> 
> g.

I just tried it and it works for me.  Dsd said he'd give it a try
with his DT matching stuff tomorrow.

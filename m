Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1AEXek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:34:40 -0500
Received: from ozlabs.org ([203.10.76.45]:54253 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab1AEXej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:34:39 -0500
Date: Thu, 6 Jan 2011 10:20:39 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] x86/dtb: Add a device tree for CE4100
Message-ID: <20110105232039.GA8846@yookeroo>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Grant Likely <grant.likely@secretlab.ca>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	sodaville@linutronix.de, devicetree-discuss@lists.ozlabs.org,
	x86@kernel.org, linux-kernel@vger.kernel.org
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
 <1292600033-12271-4-git-send-email-bigeasy@linutronix.de>
 <20101230085122.GE11721@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101230085122.GE11721@angua.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 01:51:22AM -0700, Grant Likely wrote:
> On Fri, Dec 17, 2010 at 04:33:41PM +0100, Sebastian Andrzej Siewior wrote:
[snip]
> > +/dts-v1/;
> > +/ {
> > +	model = "Intel,FalconFalls";
> > +	compatible = "Intel,FalconFalls";
> 
> To-date the convention has been to use all lowercase in compatible
> properties.  Ditto throughout this file.

IEEE1275 actually explicitly gives the convention on p164, in the
context of the "name" property.  The vendor string can either be all
uppercase, in which case it must be a stock ticker symbol ("AAPL" is
seen in the wild, for example), or it can be another string with no
uppercase.

I'm sure some intel peripheral chips must have been used on existing
OF platforms at various points.  It might be worth seeking those out
and double checking what was used in those cases.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

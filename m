Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab1BXDZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 22:25:47 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:51189 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab1BXDZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 22:25:45 -0500
Date: Wed, 23 Feb 2011 20:25:39 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: Daniel Drake <dsd@laptop.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [PATCH] of/pdt: allow DT device matching by fixing 'name'
 brokenness (v3)
Message-ID: <20110224032539.GA22111@angua.secretlab.ca>
References: <20110223150357.5a40793d@queued.net>
 <20110223232815.GC5404@angua.secretlab.ca>
 <20110223163442.2974bd66@queued.net>
 <20110224024708.GA12139@angua.secretlab.ca>
 <20110223185152.7e3c29a9@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223185152.7e3c29a9@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 06:51:52PM -0800, Andres Salomon wrote:
> On Wed, 23 Feb 2011 19:47:08 -0700
> Grant Likely <grant.likely@secretlab.ca> wrote:
> > This addresses one of my comments on v2; but it doesn't address the
> > comment that the broken implementation of of_pdt_node_name for
> > non-sparc still remains, or am I missing something?
> > 
> > g.
> > 
> 
> 
> I responded to that -
> http://www.spinics.net/lists/sparclinux/msg08058.html

Weird; that reply didn't show up in my inbox (but my mailer did
receive it, so it is definitely a problem on my end).  I'll reply
now...

g.


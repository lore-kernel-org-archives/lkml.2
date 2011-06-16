Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab1FPQ5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:57:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54270 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab1FPQ5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:57:45 -0400
Date: Thu, 16 Jun 2011 10:57:40 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 03/11] dt/irq: add irq_domain_add_simple() helper
Message-ID: <20110616165740.GH3795@ponder.secretlab.ca>
References: <20110616042653.29371.2052.stgit@ponder>
 <20110616044141.29371.76366.stgit@ponder>
 <4DFA0D83.6070604@gmail.com>
 <4DFA1160.5020208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFA1160.5020208@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 09:21:20AM -0500, Rob Herring wrote:
> Forgot one thing.
> 
> On 06/16/2011 09:04 AM, Rob Herring wrote:
> > Grant,
> > 
> > On 06/15/2011 11:41 PM, Grant Likely wrote:
> >> irq_domain_add_simple() is an easy way to generate an irq translation
> >> domain for simple irq controllers.  It assumes a flat 1:1 mapping from
> >> hardware irq number to an offset of the first linux irq number assigned
> >> to the controller
> >>
> 
> The description and headline are a bit out of date since adding
> irq_domain_generate_simple.

good catch.  Thanks.

g.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1AEXfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:35:46 -0500
Received: from ozlabs.org ([203.10.76.45]:54413 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab1AEXfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:35:46 -0500
Date: Thu, 6 Jan 2011 10:35:35 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: "Blanchard, Hollis" <Hollis_Blanchard@mentor.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Saxena, Deepak" <deepak_saxena@mentor.com>
Subject: Re: [PATCH] of/device: Don't register disabled devices
Message-ID: <20110105233535.GB8846@yookeroo>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	"Blanchard, Hollis" <Hollis_Blanchard@mentor.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	"Saxena, Deepak" <deepak_saxena@mentor.com>
References: <20110103230122.25772.72990.stgit@localhost6.localdomain6>
 <DD7A9A95166BF4418C4C1EB2033B6EE2038FA8E5@na3-mail.mgc.mentorg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DD7A9A95166BF4418C4C1EB2033B6EE2038FA8E5@na3-mail.mgc.mentorg.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 02:53:27PM -0800, Blanchard, Hollis wrote:
> On 01/03/2011 03:01 PM, Grant Likely wrote:
> > Device nodes with the property status="disabled" are not usable and so
> > don't register them when parsing the device tree for devices.
> >
> This is great and all, but a fair amount of driver code explicitly 
> searches the tree, rather than registering a probe function. That's why 
> our earlier patches in this area were more comprehensive.
> 
> What are your thoughts on handling those cases?

One by one.  Trying to handle the explicit searches automagically is
just asking for trouble.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

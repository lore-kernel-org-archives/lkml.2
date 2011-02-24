Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1BXCOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 21:14:44 -0500
Received: from ozlabs.org ([203.10.76.45]:33938 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab1BXCOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 21:14:44 -0500
Date: Thu, 24 Feb 2011 13:14:40 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/10] MIPS: Octeon: Add device tree source files.
Message-ID: <20110224021440.GD26300@yookeroo>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
	ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
	grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
 <1298408274-20856-3-git-send-email-ddaney@caviumnetworks.com>
 <20110223000759.GA26300@yookeroo>
 <4D655AB6.80400@caviumnetworks.com>
 <20110223234923.GA4932@yookeroo>
 <4D65BB17.4060703@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D65BB17.4060703@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 05:57:43PM -0800, David Daney wrote:
> On 02/23/2011 03:49 PM, David Gibson wrote:
> >On Wed, Feb 23, 2011 at 11:06:30AM -0800, David Daney wrote:
> >>On 02/22/2011 04:07 PM, David Gibson wrote:
> >>>On Tue, Feb 22, 2011 at 12:57:46PM -0800, David Daney wrote:
> >>>>Signed-off-by: David Daney<ddaney@caviumnetworks.com>
> >>>>---
> >>>>  arch/mips/cavium-octeon/.gitignore      |    2 +
> >>>>  arch/mips/cavium-octeon/Makefile        |   13 ++
> >>>>  arch/mips/cavium-octeon/octeon_3xxx.dts |  314 +++++++++++++++++++++++++++++++
> >>>>  arch/mips/cavium-octeon/octeon_68xx.dts |   99 ++++++++++
> >>>>  4 files changed, 428 insertions(+), 0 deletions(-)
> >>>>  create mode 100644 arch/mips/cavium-octeon/.gitignore
> >>>>  create mode 100644 arch/mips/cavium-octeon/octeon_3xxx.dts
> >>>>  create mode 100644 arch/mips/cavium-octeon/octeon_68xx.dts
> >>>>
> >>>>diff --git a/arch/mips/cavium-octeon/.gitignore b/arch/mips/cavium-octeon/.gitignore
> >>>>new file mode 100644
> >>>>index 0000000..39c9686
> >>>>--- /dev/null
> >>>>+++ b/arch/mips/cavium-octeon/.gitignore
> >>>>@@ -0,0 +1,2 @@
> >>>>+*.dtb.S
> >>>
> >>>.dtb.S?
> >>
> >>I think I have the correct .gitignore syntax.
> >
> >What I meant was, where are you generating .dtb.S files that you need
> >to ignore them?
> >
> 
> They are a byproduct of $(call cmd,dtc).
> 
> Normally make removes them automatically, but if you abort at just
> the right time, they can be left around.
> 
> If it is objectionable, I can just remove that .gitignore bit.

No, if they're byproducts of cmd,dtc they should be there.  I'm just a
bit baffled as to why cmd,dtc would produce such byproducts.  dtc
itself will convert dts -> dtb without any extraneous intermediate
steps.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

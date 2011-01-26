Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab1AZTnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:43:50 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:47106 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab1AZTnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:43:49 -0500
Date: Wed, 26 Jan 2011 14:43:01 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org
Subject: Re: [PATCH] dt: Move device tree documentation out of powerpc
 directory
Message-ID: <20110126194301.GA13541@zod.rchland.ibm.com>
References: <1296062434-18027-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296062434-18027-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 10:20:34AM -0700, Grant Likely wrote:
>The device tree is used by more than just PowerPC.  Make the documentation
>directory available to all.
>
>Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>---
>
>Assuming nobody has an issue with this, I'll push it out to Linus for
>2.6.38 since it is only a documentation change.
>
>g.
>
> .../bindings}/4xx/cpm.txt                          |    0
> .../bindings}/4xx/emac.txt                         |    0
> .../bindings}/4xx/ndfc.txt                         |    0
> .../bindings}/4xx/ppc440spe-adma.txt               |    0
> .../bindings}/4xx/reboot.txt                       |    0

This should probably be renamed to ...bindings}/powerpc4xx/ in that
case.  Similarly for fsl (even more so since they have ARM parts too).

Also the booting-without-of.txt file is very powerpc specific.  So I
would suggest either creating a powerpc/ directory under /bindings or
something similar.

Opinions?

josh

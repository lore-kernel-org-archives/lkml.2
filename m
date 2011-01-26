Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab1AZTMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:12:13 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:42807 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab1AZTMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:12:12 -0500
Date: Wed, 26 Jan 2011 20:12:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org
Subject: Re: [PATCH] dt: Move device tree documentation out of powerpc
	directory
Message-ID: <20110126191210.GA3377@merkur.ravnborg.org>
References: <1296062434-18027-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296062434-18027-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 10:20:34AM -0700, Grant Likely wrote:
> The device tree is used by more than just PowerPC.  Make the documentation
> directory available to all.

How does the planned stucture look like for this
new directory?
I see that in your move the architecture is dropped.
But some of these looks like they are arch candidates.
The 4xx/* for example looks like powerpc stuff that
should be in a powerpc directory.

Another is sja1000. This is obviously a can driver.
So how about mirroring the kernel structure:

Proposal:

drivers/net/can   <=== sja1000.txt
drivers/ata/      <=== fsl/sata.txt
arch/powerpc      <=== powerpc specific stuff

This is a bit more effort but then we end
up with a well-known structure.

	Sam

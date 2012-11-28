Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab2K1Xe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 18:34:28 -0500
Received: from gate.crashing.org ([63.228.1.57]:50274 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863Ab2K1Xe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 18:34:26 -0500
Message-ID: <1354145291.2179.147.camel@pasglop>
Subject: Re: [PATCH V7 1/7] kbuild: centralize .dts->.dtb rule
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Paul Mackerras <paulus@samba.org>, Michal Marek <mmarek@suse.cz>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Kumar Gala <galak@kernel.crashing.org>
Date: Thu, 29 Nov 2012 10:28:11 +1100
In-Reply-To: <50B65903.1050400@wwwdotorg.org>
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
	 <50B65903.1050400@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-28 at 11:33 -0700, Stephen Warren wrote:

> Following this patch (http://lkml.org/lkml/2012/11/27/555), I posted a
> series of patches to convert almost all architectures to using the
> centralized rule. The one architecture I didn't convert was PowerPC.
> 
> I didn't convert it because arch/powerpc/boot/Makefile contains a large
> number of rules (to generate *Image.% where % is a board name) that
> depend on %.dtb, which is expected to be in arch/powerpc/boot rather
> than arch/powerpc/boot/dts. Now, I guess it's possible to convert them
> all to expect the .dtb files to be in dts/ and also have
> arch/powerpc/boot/Makefile call make in boot/dts/ to make each required
> .dtb file. However, the patch would be a bit larger than all the other
> architecture patches. Do you want me to do that conversion, or would you
> rather I leave PowerPC alone? Thanks for any feedback.

Kumar, any objection to moving the dtb's to arch/powerpc/boot/dtb/ ?
Other than breaking a script or two out there ...

Cheers,
Ben.



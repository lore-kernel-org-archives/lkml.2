Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab0HPW31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 18:29:27 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:35621 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab0HPW30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 18:29:26 -0400
Subject: Re: [PATCH] modules: don't call depmod when overriding external
 module install path
From: Jon Masters <jonathan@jonmasters.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jon Masters <jcm@jonmasters.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
In-Reply-To: <201008162013.46252.rusty@rustcorp.com.au>
References: <1281945814-9720-1-git-send-email-jcm@jonmasters.org>
	 <201008162013.46252.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 16 Aug 2010 18:26:33 -0400
Message-ID: <1281997594.27736.232.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 20:13 +0930, Rusty Russell wrote:
> On Mon, 16 Aug 2010 05:33:34 pm Jon Masters wrote:
> > Recent kernels include an additional call to depmod during the installation
> > of external kernel modules as a convenience, in order to ensure that those
> > modules are picked up by the module loading tools/initramfs scripts, etc.
> > Although this call is potentially of some value, it should not be made
> > when explicitly setting INSTALL_MOD_PATH to a different location. This
> > avoids creating extraneous modules.* files that will never be used.
> > 
> > Signed-off-by: Jon Masters <jcm@jonmasters.org>
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> I leave the Makefile stuff to the kbuild people...

Hey, thanks for forwarding. I figured I would do that, but I see you
already did. And yea, next time I'll ping the Kbuild folks directly.

Jon.



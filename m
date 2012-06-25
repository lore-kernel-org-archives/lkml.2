Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab2FYOGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 10:06:17 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:33936 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab2FYOGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 10:06:15 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av9QAFRv6E9V5qg+PGdsb2JhbABEihWsFRkBAQEBNzSCGAEBBTocEwEPEAgDDgouFCUKGhOID7hdFIsfhSJgA5UthWaMfQ
X-IronPort-AV: E=Sophos;i="4.77,472,1336341600"; 
   d="scan'208";a="145961059"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 25 Jun 2012 16:09:24 +0200
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jan Beulich <jbeulich@suse.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Fix the Kconfig option for generic device handling
Message-ID: <20120625140924.GA489@polaris.bitmath.org>
References: <1340356390-4614-1-git-send-email-rydberg@euromail.se>
 <alpine.LNX.2.00.1206251537190.18612@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1206251537190.18612@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 03:38:40PM +0200, Jiri Kosina wrote:
> On Fri, 22 Jun 2012, Henrik Rydberg wrote:
> 
> > The generic HID driver is obviously not a special driver, so move
> > it outside of the special drivers menu. Explain the usage and make
> > the default follow the HID setting. This should simplify migration
> > from older kernels.
> > 
> > Reported-by: Jan Beulich <jbeulich@suse.com>
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> > Hi Jiri,
> > 
> > As pointed out by Jan Beulich, the generic hid driver Kconfig option
> > is confusing. This patch ought to fix most of the concerns. For 3.5.
> 
> The change makes sense. I'd however propose to perhaps unify 
> CONFIG_HID_SUPPORT and CONFIG_HID, while we are at it ... ?

I started out doing precisely that, but I wanted the 3.5 patch to be
as small as possible... I will increase the scope slightly and resend.

Cheers,
Henrik

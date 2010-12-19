Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab0LSIiD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 03:38:03 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:57051 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab0LSIiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 03:38:01 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 19 Dec 2010 09:37:47 +0100
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] Input: Fix double equality sign in uevent
Message-ID: <20101219083746.GA5892@polaris.bitmath.org>
References: <1292700717-1610-1-git-send-email-rydberg@euromail.se>
 <20101219080427.GA10074@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101219080427.GA10074@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PUEmC-0005m8-Ca.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PUEmC-0005m8-Ca 39a67bcb4d2a901b32fa2438c2d2700b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 12:04:28AM -0800, Dmitry Torokhov wrote:
> On Sat, Dec 18, 2010 at 08:31:57PM +0100, Henrik Rydberg wrote:
> > Looking at the uevent stream for input devices, all properties
> > are on the form "A=B" except the bitmap values, which are on the
> > form "A==B". Remedied with this patch.
> > 
> > Cc: stable@kernel.org
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> > Hi Dmitry,
> > 
> > Unless the input bitmap properties should really behave differently,
> > this patch ought to be a candidate for 2.6.37.
> > 
> 
> Hmm, I do not think so because:
> 
> - either nobody uses bitmap variables and then it is not priority
> - users worked around the problem and by applying fix we'd be
>   breaking their setups.
> 
> I think we should apply it but at the beginning of .38 cycle to give us
> a chance to evaluate and maybe revert.
> 
> Does this make sense?

Indeed, since the problem has been around at least since 2007, it makes perfect sense.

Thanks,
Henrik

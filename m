Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab1HADKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 23:10:31 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44722 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab1HADK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 23:10:26 -0400
Date: Sun, 31 Jul 2011 20:10:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Michal Simek <monstr@monstr.eu>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] input: xilinx_ps2: Add missing of_address.h header
Message-ID: <20110801031021.GB23944@core.coreip.homeip.net>
References: <1310564781-5979-1-git-send-email-monstr@monstr.eu>
 <CACxGe6vRZ4tCALpzFng2y9W_9zB3qQEntma+z292FXzDuYBRKQ@mail.gmail.com>
 <4E2C2362.1080204@monstr.eu>
 <20110731041230.GO24334@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110731041230.GO24334@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 10:12:30PM -0600, Grant Likely wrote:
> On Sun, Jul 24, 2011 at 03:51:30PM +0200, Michal Simek wrote:
> > Hi Grant,
> > 
> > can you propose this patch to mainline through your devicetree tree?
> 
> I've got it in a "input/next" branch.  Since the input maintainer
> doesn't seem to be active on driver patches, I'll send a pull req to
> Linus.

CCing me on patches usually helps... Yes, please feel free to push
through your tree if you'd like.

-- 
Dmitry

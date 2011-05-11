Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab1EKPxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:53:21 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:44850 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755315Ab1EKPxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:53:18 -0400
Date: Wed, 11 May 2011 10:51:34 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        Linux PCMCIA team <linux-pcmcia@lists.infradead.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL PATCH 0/3] pcmcia: Make struct pcmcia_device_id const
Message-ID: <20110511085134.GA27606@comet.dominikbrodowski.net>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Jiri Kosina <trivial@kernel.org>,
	Linux PCMCIA team <linux-pcmcia@lists.infradead.org>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <cover.1304475547.git.joe@perches.com>
 <20110506061527.GA26026@comet.dominikbrodowski.net>
 <1304705095.11874.21.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304705095.11874.21.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 11:04:55AM -0700, Joe Perches wrote:
> On Fri, 2011-05-06 at 08:15 +0200, Dominik Brodowski wrote:
> > On Tue, May 03, 2011 at 07:28:59PM -0700, Joe Perches wrote:
> > > Reduces data use.
> > > Staging could be applied now, but additional harmless warnings do result.
> > > Joe Perches (3):
> > >   pcmcia: Make declaration and uses of struct pcmcia_device_id const
> > >   pcmcia: Convert pcmcia_device_id declarations to const
> > >   staging: pcmcia: Convert pcmcia_device_id declarations to const
> > Thanks, applied all three patches to the pcmcia git tree.
> 
> Hi Dominik, just so you're aware...
> 
> By the time your tree gets pushed, there'll likely
> be conflicts with staging changes.

Well, -next doesn't show any issues so far. *knock on wood*

> There are also a couple of uses of pcmcia_device_id
> in sound/ that could be modified.
> 
> $ grep -rPwn --include=*.[ch] pcmcia_device_id sound
> sound/pcmcia/vx/vxpocket.c:353:static struct pcmcia_device_id vxp_ids[] = {
> sound/pcmcia/pdaudiocf/pdaudiocf.c:281:static struct pcmcia_device_id snd_pdacf_ids[] = {
> 
> Here's a patch for those as well

Thanks, applied.

Best,
	Dominik

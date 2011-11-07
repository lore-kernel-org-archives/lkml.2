Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1KGJzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 04:55:40 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:40670 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab1KGJzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 04:55:40 -0500
Subject: Re: [PATCH] Driver for GE PIO2 VME Card
From: Paul Bolle <pebolle@tiscali.nl>
To: Martyn Welch <martyn.welch@ge.com>
Cc: gregkh@suse.de, Grant Likely <grant.likely@secretlab.ca>,
        devel@driverdev.osuosl.org, manohar.vanga@cern.ch, cota@braap.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4EB7A60D.801@ge.com>
References: <20111104173126.30940.28135.stgit@ES-BJ21R4J>
	 <1320436514.14409.309.camel@x61.thuisdomein>  <4EB7A60D.801@ge.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 10:55:29 +0100
Message-ID: <1320659729.14409.349.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 09:34 +0000, Martyn Welch wrote:
> On 04/11/11 19:55, Paul Bolle wrote:
> >> +	  implementing 32 solid-state relay switched IO lines, in 4 groups of 8.
> >> +	  The IO lines are provided as input, output or both as a build time
> >> +	  option.
> > 
> > What option would that be? 
> 
> I think "Each bank of IO lines is pre-configured as input, output or both
> depending on the variant of the card" may be a bit clearer?

So this concerns a physical build option! Anything that makes that clear
(like your alternative does) is fine with me. (Perhaps "is
pre-configured" could be "functions", as that's less ambiguous in a
Kconfig file, but that's debatable.)

> > All module parameters have a sysfs visibility (or permission) of zero.
> > Why is that? (This might very well be a naive question. But I often
> > wonder why a certain parameter's permission isn't at least 400, just to
> > allow a quick check of that parameter.) Are arrays tricky in sysfs? 
> 
> Hadn't really thought about it to be honest. There seems to be plenty of
> examples where it's set to non-zero.

(Perhaps you meant to write "set to zero" here.)

Greg already explained that it's OK to leave the code as is for now
(since all these control knobs need to be provided via "real" sysfs
files in the long run anyhow).


Paul Bolle


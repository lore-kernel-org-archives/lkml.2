Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab0HFPb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 11:31:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60296 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab0HFPbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 11:31:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B4b2EA+V1elHncwhWLpfxwN9T0+juHuVXxDz1SI905QP/iyTZbK5TD3CbKvg6waRUs
         Z9PfIjramn8tzY6i9M2GS1jYTi0Fy2vSceZvxHeFqjYbLcMMxWVnrEgFtilfjuwMDwUN
         FH+xgo354HHkrb1rKi/6x0Yz0RCjpRMeUpJqg=
Date: Fri, 6 Aug 2010 17:31:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 07/10] ftrace: pass KBUILD_CFLAGS to record_mcount.pl
Message-ID: <20100806153114.GA5345@nowhere>
References: <1268462987-8271-1-git-send-email-rabin@rab.in> <1268462987-8271-8-git-send-email-rabin@rab.in> <20100803164247.GA6133@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803164247.GA6133@debian>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 10:12:47PM +0530, Rabin Vincent wrote:
> Steven, Frederic,
> 
> I'd like to resurrect this old ARM dynamic ftrace patchset.  It still
> applies on next except for a small merge conflict in one of the
> ARM-specific patches.
> 
> On Sat, Mar 13, 2010 at 12:19:44PM +0530, Rabin Vincent wrote:
> > On ARM, we have two ABIs, and the ABI used is controlled via a config
> > option.  Object files built with one ABI can't be merged with object
> > files built with the other ABI.  So, record_mcount.pl needs to use the
> > same compiler flags as the kernel when generating the object file with
> > the mcount locations.  Ensure this by passing CFLAGS to the script.
> > 
> > Signed-off-by: Rabin Vincent <rabin@rab.in>
> 
> This is the only non-arch/arm/ patch in the series which doesn't have
> either of your Acked-bys, so if you'd be willing to ack it, I'll send in
> the lot via rmk's ARM patch system for .37.
> 
> Alternatively, this one and "[PATCH 03/10] ftrace: allow building
> without frame pointers" could go in via the tracing tree for .36?  Then
> I'll send in the ARM specific stuff for .37 via the ARM tree.
> 
> Thanks,
> Rabin



I'll let Steve handling this one as I have few skills with things that touch
scripts/recordmcount.pl :)


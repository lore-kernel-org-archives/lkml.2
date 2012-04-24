Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2DXHlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 03:41:55 -0400
Received: from gw1.transmode.se ([195.58.98.146]:44533 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab2DXHly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 03:41:54 -0400
In-Reply-To: <1335237195.24897.0.camel@pasglop>
References: <1335220202-32533-1-git-send-email-grant.likely@secretlab.ca>	 <1335220202-32533-2-git-send-email-grant.likely@secretlab.ca> <1335237195.24897.0.camel@pasglop>
Subject: Re: [PATCH v2 1/2] powerpc/8xx: Fix NR_IRQ bugs and refactor 8xx interrupt
 controller
X-KeepSent: 4123672B:F86C969F-C12579EA:002A2C1F;
 type=4; name=$KeepSent
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OF4123672B.F86C969F-ONC12579EA.002A2C1F-C12579EA.002A48C2@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Tue, 24 Apr 2012 09:41:51 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP1|March 07, 2012) at
 24/04/2012 09:41:51
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote on 2012/04/24 05:13:15:
>
> On Mon, 2012-04-23 at 16:30 -0600, Grant Likely wrote:
> > The mpc8xx driver uses a reference to NR_IRQS that is buggy.  It uses
> > NR_IRQs for the array size of the ppc_cached_irq_mask bitmap, but
> > NR_IRQs could be smaller than the number of hardware irqs that
> > ppc_cached_irq_mask tracks.
>
> Joakim, any chance you can test this ASAP ? :-)

Sorry, but no.  We have not moved our 8xx boards to 3.x as it in maintenance
and takes too much space.


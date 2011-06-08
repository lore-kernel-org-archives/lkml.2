Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1FHM06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 08:26:58 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:39671 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab1FHM06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 08:26:58 -0400
Subject: Re: [PATCH v3] dma-debug: print some unfreed allocations
From: Johannes Berg <johannes@sipsolutions.net>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110608121608.GA21591@amd.com>
References: <1305052944.3544.8.camel@jlt3.sipsolutions.net>
	 <1305118077.3416.5.camel@jlt3.sipsolutions.net>
	 <20110516110029.GC31309@amd.com>
	 <1305758908.8827.3.camel@jlt3.sipsolutions.net>
	 <20110519081931.GM31309@amd.com>
	 <1305909418.4640.13.camel@jlt3.sipsolutions.net>
	 <20110523123508.GC27867@amd.com>
	 <1307531016.3961.5.camel@jlt3.sipsolutions.net>
	 <20110608121608.GA21591@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 14:26:47 +0200
Message-ID: <1307536007.30277.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 14:16 +0200, Roedel, Joerg wrote:

> > I see something similar was merged printing just the first one (and
> > without stack trace it seems?). Are you still interested in this?
> 
> Sure, still interested. The code which prints out the first entry has
> been around for some time, its nothing new afaik.

Ok. I was thinking of 
commit ba4b87ad5497cba555954885db99c99627f93748
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Thu Mar 31 08:08:09 2011 -0400

    dma-debug: print information about leaked entry

which is fairly recent, recent enough that my original patch no longer
applied anyway :-)

johannes


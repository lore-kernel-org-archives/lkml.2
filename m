Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2GRRFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 13:05:49 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39776 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158Ab2GRRFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 13:05:47 -0400
Date: Wed, 18 Jul 2012 13:05:42 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/17] input/serio/hp_sdc.c: remove IRQF_SAMPLE_RANDOM
 which is now a no-op
Message-ID: <20120718170542.GA22107@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
 <1342560756-18737-3-git-send-email-tytso@mit.edu>
 <20120718060913.GA23668@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120718060913.GA23668@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 11:09:13PM -0700, Dmitry Torokhov wrote:
> On Tue, Jul 17, 2012 at 05:32:21PM -0400, Theodore Ts'o wrote:
> > With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
> > no-op; interrupt randomness is now collected unconditionally in a very
> > low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
> > flag was scheduled to be removed in 2009 on the
> > feature-removal-schedule, so this patch is preparation for the final
> > removal of this flag.
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> I assume you'll be merging it through random tree with the rest of the
> patches?

Yes, correct.

Thanks!!

						- Ted

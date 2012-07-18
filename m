Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab2GRE6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 00:58:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64697 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2GRE6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 00:58:11 -0400
Date: Tue, 17 Jul 2012 21:56:09 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 04/17] pda_power: remove IRQF_SAMPLE_RANDOM which is now
 a no-op
Message-ID: <20120718045609.GA29357@lizard>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
 <1342560756-18737-5-git-send-email-tytso@mit.edu>
 <20120718040008.GA22599@lizard>
 <20120718041820.GA21747@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120718041820.GA21747@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 12:18:20AM -0400, Theodore Ts'o wrote:
> On Tue, Jul 17, 2012 at 09:00:09PM -0700, Anton Vorontsov wrote:
> > On Tue, Jul 17, 2012 at 05:32:23PM -0400, Theodore Ts'o wrote:
> > > With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
> > > no-op; interrupt randomness is now collected unconditionally in a very
> > > low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
> > > flag was scheduled to be removed in 2009 on the
> > > feature-removal-schedule, so this patch is preparation for the final
> > > removal of this flag.
> > > 
> > > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > > Cc: Anton Vorontsov <cbou@mail.ru>
> > > Cc: David Woodhouse <dwmw2@infradead.org>
> > > ---
> > 
> > Applied, thanks!
> 
> My original plan was to carry the patch in the random.git tree, so
> that it only gets applied after the new random interrupt sampling
> commit has gone in.  If you carry it in your tree, then the
> /dev/random seeding for your platform will be worse until the
> random.git tree is merged in.....

Oh, I see. OK, dropped.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com

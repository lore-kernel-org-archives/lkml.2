Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab2EFDHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 23:07:54 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:53326 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab2EFDHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 23:07:53 -0400
Date: Sat, 5 May 2012 20:06:18 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Nikolaus Voss <n.voss@weinmann.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/power/sbs-battery.c: capacity attr = remaining
 relative capacity
Message-ID: <20120506030618.GE29576@lizard>
References: <201204250721.q3P7LmQN009128@gatekeeper.vosshq.de>
 <1336145083.2210.1.camel@rhyland-vb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1336145083.2210.1.camel@rhyland-vb>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 08:24:43AM -0700, Rhyland Klein wrote:
> On Tue, 2012-04-24 at 23:59 -0700, Nikolaus Voss wrote:
> > Currently, the capacity exported by this driver refers to reg 0x0e,
> > which is the absolute state of charge which according to SBS
> > refers to the design capacity/ energy of the battery. It can be
> > > 100 % and drops below 100 % for a fully charged battery with
> > the battery aging.
> > 
> > This is not what the user exspects of a remaining capacity
> > indication between 0 and 100 % with 100 % referring to
> > a fully charged battery. This is provided by SBS reg 0x0d,
> > which is the relative state of charge referring to the
> > full charge capacity.
> > 
> > Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
> > ---
> >  drivers/power/sbs-battery.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Ack-ed Rhyland Klein <rklein@nvidia.com>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com

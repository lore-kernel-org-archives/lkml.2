Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965Ab1KJIHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:07:23 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:36559 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933670Ab1KJIHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:07:20 -0500
Date: Thu, 10 Nov 2011 09:07:02 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Make dmi_name_in_vendors more focused
Message-ID: <20111110090702.6187e8f9@endymion.delvare>
In-Reply-To: <20111110043520.47e78e9c@jbarnes-x220>
References: <20111104102647.0b3eba22@endymion.delvare>
	<20111109142557.70cb43cb.akpm@linux-foundation.org>
	<20111110043520.47e78e9c@jbarnes-x220>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Nov 2011 04:35:20 +0100, Jesse Barnes wrote:
> On Wed, 9 Nov 2011 14:25:57 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 4 Nov 2011 10:26:47 +0100
> > Jean Delvare <khali@linux-fr.org> wrote:
> > > This patch was already sent on 2011-05-15. I thought Andrew had
> > > picked it up but apparently not, otherwise it should already be
> > > upstream by now.
> > 
> > I did merge it in May and have carried it in -mm (and hence in
> > linux-next) since then.  I have sent it to Jesse at least twice, with
> > no effect.
> 
> I don't generally look after DMI stuff...

Indeed I'm not sure why Jesse would take this, it's not PCI-related in
any way.

> I can queue it though if you
> want.  My only worry is potential breakage for existing DMI matches,
> but it looks like Jean already did the audit for that.

Yes I did, both at the time of the original submission and again when
resending.

-- 
Jean Delvare

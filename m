Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab0ENQhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:37:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47861 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab0ENQgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:36:49 -0400
Date: Fri, 14 May 2010 17:36:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 3/3] input: Default to only using PNP for i8042 probing
	on x86
Message-ID: <20100514163643.GB7843@srcf.ucam.org>
References: <1273853403-2870-1-git-send-email-mjg@redhat.com> <1273853403-2870-3-git-send-email-mjg@redhat.com> <20100514163158.GC31607@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514163158.GC31607@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 09:31:59AM -0700, Dmitry Torokhov wrote:
> On Fri, May 14, 2010 at 12:10:03PM -0400, Matthew Garrett wrote:
> > Experimenting with Windows has revealed that it will not probe the
> > keyboard controller unless a valid PNPACPI device is present. Change our
> > behaviour to match, and add a new i8042.forcedprobe parameter to allow
> > people to override it.
> > 
> 
> i8042.nopnp would not do?

It could - it wouldn't be quite semantically equivalent, but I don't see 
why it wouldn't work.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

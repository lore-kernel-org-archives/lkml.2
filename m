Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab2FVNic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:38:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab2FVNib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:38:31 -0400
Date: Fri, 22 Jun 2012 15:38:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH Stable 3.4.x] HID: hid-multitouch: fix wrong protocol
 detection
In-Reply-To: <20120620162812.GA433@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1206221538100.18612@pobox.suse.cz>
References: <1340111206-11659-1-git-send-email-benjamin.tissoires@gmail.com> <20120620162812.GA433@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012, Henrik Rydberg wrote:

> > From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> > 
> > The previous implementation introduced a randomness in the splitting
> > of the different touches reported by the device. This version is more
> > robust as we don't rely on hi->input->absbit, but on our own structure.
> > 
> > This also prepares hid-multitouch to better support Win8 devices.
> > 
> > [commit 3ac36d15557d1bedfb1151d9911b9587b2d40759 in Linus' tree]
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> > ---
> > 
> > Hi Jiri,
> > 
> > This patch is a port of the one included in the future 3.5.
> > I already had users complaining about the broken behavior in 3.4, then this
> > respin for 3.4. Kernels 3.3 and below are not impacted by the bug.
> 
>     Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks, I am pushing that for -stable.

-- 
Jiri Kosina
SUSE Labs

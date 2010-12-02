Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab0LBPVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 10:21:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57020 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757713Ab0LBPVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 10:21:09 -0500
Date: Thu, 2 Dec 2010 16:21:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tobias Karnat <tobias.karnat@googlemail.com>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: edac_core: crashes on shutdown
Message-ID: <20101202152106.GA29301@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tobias Karnat <tobias.karnat@googlemail.com>,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1291201307.3029.21.camel@Tobias-Karnat>
 <20101201123921.GA15530@a1.tnic>
 <1291209888.12511.11.camel@Tobias-Karnat>
 <20101201143329.GB18074@a1.tnic>
 <1291225614.8646.4.camel@Tobias-Karnat>
 <20101201193508.GA4916@liondog.tnic>
 <1291280613.10626.22.camel@Tobias-Karnat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1291280613.10626.22.camel@Tobias-Karnat>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 10:03:33AM +0100, Tobias Karnat wrote:
> > Also, can you disable the EDAC subsystem in Kconfig and retry?
> > I'm trying to rule out some other issue since the backtraces are
> > inconclusive wrt EDAC.
> > 
> > Thanks.
> 
> Yes, maybe on the weekend, but as I said replacing the modules with
> compiled from older src does work fine.

Well, thanks for the photos. I don't have an idea what might cause this
workqueue corruption I'm seeing, all reg/unreg paths look ok. The only
change that came in between .35 and .36.1 I can think of being relevant
is 00740c58541b6087d78418cebca1fcb86dc6077d. You could try backing that
one out to see whether it fixes the issue.

-- 
Regards/Gruss,
Boris.

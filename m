Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab1HAODj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 10:03:39 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:4790 "EHLO CERNMX30.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab1HAODe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 10:03:34 -0400
Date: Mon, 1 Aug 2011 16:00:36 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Martyn Welch <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] staging: vme: make [alloc|free]_consistent bridge
 specific
Message-ID: <20110801140036.GA9670@becoht-mvanga>
Mail-Followup-To: Martyn Welch <martyn.welch@ge.com>, gregkh@suse.de,
	cota@braap.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-4-git-send-email-manohar.vanga@cern.ch>
 <4E36AD01.1050004@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E36AD01.1050004@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martyn,

> > Make PCI dependent functions ([alloc|free]_consistent() in
> > 'vme.c') bridge specific. By removing the dependency of the
> > VME bridge framework on PCI, this patch allows for addition of
> > non-PCI based VME bridges.
> > 
> 
> I like the approach, I think I agree with Dan, I'd rather see the locking
> inside the function for now.

Just noticed that the locking that Dan was referring to and the one you agree
with in the previous patch ([PATCH 2/8] staging: vme: allow explicit assignment
of bus numbers) and not this one. Which one are you referring to here?

--
/manohar

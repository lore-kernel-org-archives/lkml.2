Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118Ab2JKS2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 14:28:04 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:35713 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab2JKS2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 14:28:01 -0400
Date: Thu, 11 Oct 2012 18:28:00 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: "Poddar\\, Sourav" <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>
cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        gregkh@linuxfoundation.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not
 suspended.
In-Reply-To: <87ipas2y4h.fsf@deeprootsystems.com>
Message-ID: <alpine.DEB.2.00.1210111748010.5736@utopia.booyaka.com>
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com> <CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com> <20120925083029.GG31374@n2100.arm.linux.org.uk> <20120925083118.GI9137@arwen.pp.htv.fi> <20120925091228.GI31374@n2100.arm.linux.org.uk>
 <20120925091112.GK9137@arwen.pp.htv.fi> <20120925092118.GJ31374@n2100.arm.linux.org.uk> <CAKdam57bpTJ94Gn=mKVw1Fm-76fVPp3DGjFuNu_HfesybM1hPg@mail.gmail.com> <87ipas2y4h.fsf@deeprootsystems.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Sourav, Felipe,

any progress on fixing the N800 problem?  Would be good to keep it booting 
since we use it as our primary 2420 test platform.


- Paul

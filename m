Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0H1A3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 20:29:11 -0400
Received: from relay1.sgi.com ([192.48.179.29]:38709 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab0H1A3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 20:29:09 -0400
Date: Sat, 28 Aug 2010 01:28:55 +0100
From: Hedi Berriche <hedi@sgi.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Petr Tesarik <ptesarik@suse.cz>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Serious problem with ticket spinlocks on ia64
Message-ID: <20100828002855.GI18967@zorg.emea.sgi.com>
Mail-Followup-To: "Luck, Tony" <tony.luck@intel.com>,
	Petr Tesarik <ptesarik@suse.cz>,
	"linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201008271537.35709.ptesarik@suse.cz> <201008272303.34228.ptesarik@suse.cz> <987664A83D2D224EAE907B061CE93D53015D91D45F@orsmsx505.amr.corp.intel.com> <201008280013.19941.ptesarik@suse.cz> <987664A83D2D224EAE907B061CE93D53015D91D604@orsmsx505.amr.corp.intel.com> <987664A83D2D224EAE907B061CE93D53015D91D645@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D53015D91D645@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 00:55 Tony Luck wrote:
| > this fails so catastrophically
| 
| Interesting ... getting rid of some of the fancy asm bits
| (replacing both the ld4.c.nc and the ld2.bias with simple
| "serve = *p" and "tmp = *p") makes this run a lot better.

*Hasty* look seems to suggest that keeping the fancy asm bits but compiling with
-O2 -frename-registers makes it work equally well.

Don't take my word for it though, double check it, it's been a long week and
brain is anything but alert at this time of the night.

Cheers,
Hedi.
-- 
Hedi Berriche
Global Product Support
http://www.sgi.com/support

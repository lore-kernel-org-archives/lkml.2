Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0H0SUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:20:50 -0400
Received: from relay3.sgi.com ([192.48.152.1]:56817 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755189Ab0H0SUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:20:47 -0400
Date: Fri, 27 Aug 2010 19:20:39 +0100
From: Hedi Berriche <hedi@sgi.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Serious problem with ticket spinlocks on ia64
Message-ID: <20100827182039.GC18967@zorg.emea.sgi.com>
Mail-Followup-To: Petr Tesarik <ptesarik@suse.cz>,
	"Luck, Tony" <tony.luck@intel.com>,
	"linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201008271537.35709.ptesarik@suse.cz> <987664A83D2D224EAE907B061CE93D53015D91D029@orsmsx505.amr.corp.intel.com> <201008271916.30369.ptesarik@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008271916.30369.ptesarik@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 18:16 Petr Tesarik wrote:
| On Friday 27 of August 2010 18:08:03 Luck, Tony wrote:
| > > Hedi Berriche sent me a simple test case that can
| > > trigger the failure on the siglock.
| >
| > Can you post the test case please. How long does it typically take
| > to reproduce the problem?
| 
| I let Hedi send it. It's really easy to reproduce. In fact, I can reproduce it 
| within 5 minutes on an 8-CPU system.

Test case provided via private email.

Cheers,
Hedi.
-- 
Hedi Berriche
Global Product Support
http://www.sgi.com/support

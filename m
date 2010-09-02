Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab0IBA0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 20:26:53 -0400
Received: from relay1.sgi.com ([192.48.179.29]:44274 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab0IBA0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 20:26:52 -0400
Date: Thu, 2 Sep 2010 01:26:41 +0100
From: Hedi Berriche <hedi@sgi.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Petr Tesarik <ptesarik@suse.cz>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Serious problem with ticket spinlocks on ia64
Message-ID: <20100902002641.GI18967@zorg.emea.sgi.com>
Mail-Followup-To: Tony Luck <tony.luck@intel.com>,
	Petr Tesarik <ptesarik@suse.cz>,
	"linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201008271537.35709.ptesarik@suse.cz> <987664A83D2D224EAE907B061CE93D53015D91D6F5@orsmsx505.amr.corp.intel.com> <987664A83D2D224EAE907B061CE93D53015D9B14DC@orsmsx505.amr.corp.intel.com> <201008302341.14312.ptesarik@suse.cz> <AANLkTin4cn84xu3go-Tj-CYSLp0W6uO1HRtA6_CQu8nJ@mail.gmail.com> <AANLkTinHOpcdAJd0_4G=OFAnMZaXKeOsqnbjJMAxCume@mail.gmail.com> <AANLkTikUrNcuZB_CFn5cGFovN8U4eyPGL=nEdSP3JS9Z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikUrNcuZB_CFn5cGFovN8U4eyPGL=nEdSP3JS9Z@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 00:10 Tony Luck wrote:
| More results from other experiments ...
| 
| 1) It occurred to me that I should check that these test cases weren't
| hitting some other problem in 2.6.36-rc3. So I ported the 64-bit
| version of ticket locks to the current kernel and ran the stress test.
| It was still going strong at 16 hours (where all my other experiments
| tend to fail at 90 minutes or less).

This is consistent with the bisection that led me to the 4 bytes ticket
locks commit.

| Summary: the only change that helps is the 64-bit ticket locks.

Ditto.

Cheers,
Hedi.
-- 
Hedi Berriche
Global Product Support
http://www.sgi.com/support

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab0LRPcD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:32:03 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:35673 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020Ab0LRPcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:32:01 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 18 Dec 2010 16:31:49 +0100
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/2 V3] applesmc: Use PnP rather than hardcoding
 resources and devices
Message-ID: <20101218153149.GB1506@polaris.bitmath.org>
References: <20101217221618.GA13207@ericsson.com>
 <1292624661-32474-1-git-send-email-mjg@redhat.com>
 <20101218042320.GA14104@ericsson.com>
 <20101218090714.GA436@polaris.bitmath.org>
 <20101218144049.GA21801@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101218144049.GA21801@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PTylD-0005Xi-AX.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PTylD-0005Xi-AX 7c478de5ada4cfa724abc10178f29d2b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I tested under EFI and BIOS. NOTIFICATION_KEY is there for adding 
> interrupt support - I got that hooked up but it seems that the latest 
> Air is lacking the sudden motion sensor (probably because it's an 
> SSD-only model) so wasn't able to test it. I'll play some more and add a 
> further patch for that.

Sounds interesting. Please add the define in that patch instead.

Thanks,
Henrik

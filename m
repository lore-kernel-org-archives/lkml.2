Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab0GZW3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:29:20 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41524 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab0GZW3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:29:19 -0400
Date: Mon, 26 Jul 2010 23:29:09 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        David Quan <David.Quan@atheros.com>,
        "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>
Subject: Re: [ath5k-devel] [PATCH v3] ath5k: disable ASPM
Message-ID: <20100726222909.GA6773@srcf.ucam.org>
References: <1276952554.3332.3.camel@maxim-laptop> <1276961564.5173.12.camel@maxim-laptop> <20100726201322.GI14855@tux> <1280177362.3721.7.camel@maxim-laptop> <20100726210651.GJ14855@tux> <1280179033.3721.15.camel@maxim-laptop> <20100726212543.GA5424@srcf.ucam.org> <AANLkTi=5_Dc8SumPi7cr8u7=DmnOHgSo6C76w9b0E4Kj@mail.gmail.com> <20100726222113.GA6487@srcf.ucam.org> <AANLkTinq-SxMHTrJM23WaeRMkU-2cySiVrkwCjDRS_o+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinq-SxMHTrJM23WaeRMkU-2cySiVrkwCjDRS_o+@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 03:26:37PM -0700, Luis R. Rodriguez wrote:

> What I meant was that the PCI config space would already have L1
> enabled if L1 worked, so I don't see why we would need to nitpick out
> specifics here. All Atheros PCIE chips should work with L1. The advise
> given is to disable L0s though. I believe AR2425 would be one which
> likely had L0s enabled but requires it to be disabled. Not sure of
> others. But this is why I am saying this can be done globally for all
> ath5k chipsets.

If L1 is set but the chip is pre-PCIe 1.1 then we'll disable L1 unless 
the driver tells us that it's functional. The .inf from the Windows 
driver seemed to suggest that only a subset of the chips re-enabled L1 
there, but if it's ok in general then that's a straightforward one-line 
patch.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

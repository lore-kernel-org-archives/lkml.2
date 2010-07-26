Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0GZWvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:51:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47178 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab0GZWvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:51:09 -0400
Date: Mon, 26 Jul 2010 23:50:57 +0100
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
Message-ID: <20100726225057.GA7268@srcf.ucam.org>
References: <20100726210651.GJ14855@tux> <1280179033.3721.15.camel@maxim-laptop> <20100726212543.GA5424@srcf.ucam.org> <AANLkTi=5_Dc8SumPi7cr8u7=DmnOHgSo6C76w9b0E4Kj@mail.gmail.com> <20100726222113.GA6487@srcf.ucam.org> <AANLkTinq-SxMHTrJM23WaeRMkU-2cySiVrkwCjDRS_o+@mail.gmail.com> <20100726222909.GA6773@srcf.ucam.org> <AANLkTinysGjYS7RKN4X_7T2q+rw_-OWdn-UJYM0poWXu@mail.gmail.com> <20100726223326.GA6904@srcf.ucam.org> <AANLkTinChEx_B9wa-n+a6xDr1vLOBOD3Mhcs=iqcYwen@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinChEx_B9wa-n+a6xDr1vLOBOD3Mhcs=iqcYwen@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 03:43:04PM -0700, Luis R. Rodriguez wrote:

> I see.. thanks Mathew... in that case since L1 works on all devices we
> could just force enable L1 for all PCIE devices. What do you think?

Works for me.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

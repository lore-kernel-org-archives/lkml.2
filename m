Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab0G1Xsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 19:48:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41607 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab0G1XsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 19:48:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=m5h18NwWVdJTg1JjTfSc7z/z0ip8Qo9Rzpru+h76GWaOXyoKXIChv+nOdJYxHzuEDQ
         uQZVAULIU/Jd3Yotewbm89jqP5l2FUxBPcM2e6ngMFHp9UzY9DvrYd1YGpcvtyqP62+O
         /f6Vhkr/O1J8BiGJQZUsYwF7wgRgn79UoVgNM=
Subject: Re: [ath5k-devel] [PATCH v3] ath5k: disable ASPM
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        David Quan <David.Quan@atheros.com>,
        "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>
In-Reply-To: <AANLkTim1sZ5ZoGcrsdCw8dFSzUj4igZOiq7irKsdbfXR@mail.gmail.com>
References: <20100726210651.GJ14855@tux>
	 <1280179033.3721.15.camel@maxim-laptop>
	 <20100726212543.GA5424@srcf.ucam.org>
	 <AANLkTi=5_Dc8SumPi7cr8u7=DmnOHgSo6C76w9b0E4Kj@mail.gmail.com>
	 <20100726222113.GA6487@srcf.ucam.org>
	 <AANLkTinq-SxMHTrJM23WaeRMkU-2cySiVrkwCjDRS_o+@mail.gmail.com>
	 <20100726222909.GA6773@srcf.ucam.org>
	 <AANLkTinysGjYS7RKN4X_7T2q+rw_-OWdn-UJYM0poWXu@mail.gmail.com>
	 <20100726223326.GA6904@srcf.ucam.org>
	 <AANLkTinChEx_B9wa-n+a6xDr1vLOBOD3Mhcs=iqcYwen@mail.gmail.com>
	 <20100726225057.GA7268@srcf.ucam.org>
	 <1280223313.3721.83.camel@maxim-laptop>
	 <AANLkTim1sZ5ZoGcrsdCw8dFSzUj4igZOiq7irKsdbfXR@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 02:48:15 +0300
Message-ID: <1280360895.8891.19.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-27 at 08:57 -0700, Luis R. Rodriguez wrote: 
> On Tue, Jul 27, 2010 at 2:35 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > On Mon, 2010-07-26 at 23:50 +0100, Matthew Garrett wrote:
> >> On Mon, Jul 26, 2010 at 03:43:04PM -0700, Luis R. Rodriguez wrote:
> >>
> >> > I see.. thanks Mathew... in that case since L1 works on all devices we
> >> > could just force enable L1 for all PCIE devices. What do you think?
> >>
> >> Works for me.
> >>
> >
> > On the second thought, there is no 'pci_enable_link_state' :-)
> > I afraid that if I add it, I might not do that right for all cases, thus
> > do more harm that good...
> 
> I'm sorry, can you elaborate?

I mean ASPM code doesn't have a function to undo effects of the
blacklist (due to pre 1.1 pcie device).

Its not that simple to write such function.

Best regards,
Maxim Levitsky


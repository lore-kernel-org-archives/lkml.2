Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab0FVQwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:52:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44564 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab0FVQwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:52:45 -0400
Date: Tue, 22 Jun 2010 17:52:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
Message-ID: <20100622165213.GA21842@srcf.ucam.org>
References: <1276870309.23783.3.camel@maxim-laptop> <1276933774.16697.11.camel@maxim-laptop> <AANLkTimIjaxq7IDWwIl1vv93k9bNQ2i89Sb5R5TiJmmA@mail.gmail.com> <1277032723.9555.12.camel@maxim-laptop> <AANLkTim8iZmm8pEERJUsrQWOiLSjPUfCN-TFFzZZQWx2@mail.gmail.com> <1277151410.5409.33.camel@maxim-laptop> <20100621233333.21262abjfxl8j1xc@hayate.sektori.org> <AANLkTikkt4dqYWrwtTCJ8tJZLB1kZXgF1KvaPsIOO3Dl@mail.gmail.com> <20100622163138.GD20668@srcf.ucam.org> <AANLkTikQkLFdpusfcLVOpyZHFrxwB5akr-ggFB7Fjm08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikQkLFdpusfcLVOpyZHFrxwB5akr-ggFB7Fjm08@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 09:48:40AM -0700, Luis R. Rodriguez wrote:

> Sure, I agree with that, but it also will enable ASPM for *all*
> devices which have the capability which IMHO is a terrible idea for
> users when all they want to do is enable ASPM for one device. Instead
> I recommend users to enable ASPM for their devices selectively and
> from userspace.

Why would you only want to enable ASPM for one device?

-- 
Matthew Garrett | mjg59@srcf.ucam.org

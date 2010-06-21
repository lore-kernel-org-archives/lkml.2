Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab0FUUdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:33:37 -0400
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:38945 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583Ab0FUUdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:33:35 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.36
Message-ID: <20100621233333.21262abjfxl8j1xc@hayate.sektori.org>
Date: Mon, 21 Jun 2010 23:33:33 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "David Quan" <David.Quan@atheros.com>,
       "Bob Copeland" <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
References: <20100528100901.14580.1322.stgit@fate.lan>
	<1276806785.20754.8.camel@maxim-laptop>
	<20100618112026.17623g6uhdjk8hts@naisho.dyndns.info>
	<1276856142.9114.1.camel@maxim-laptop>
	<20100618134930.124225d4fsi8w1fk@naisho.dyndns.info>
	<1276859156.19554.2.camel@maxim-laptop>
	<AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com>
	<1276870309.23783.3.camel@maxim-laptop>
	<1276933774.16697.11.camel@maxim-laptop>
	<AANLkTimIjaxq7IDWwIl1vv93k9bNQ2i89Sb5R5TiJmmA@mail.gmail.com>
	<1277032723.9555.12.camel@maxim-laptop>
	<AANLkTim8iZmm8pEERJUsrQWOiLSjPUfCN-TFFzZZQWx2@mail.gmail.com>
	<1277151410.5409.33.camel@maxim-laptop>
In-Reply-To: <1277151410.5409.33.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "Maxim Levitsky" <maximlevitsky@gmail.com>:

> Card (at least mine) advertises its as a 'pre pci 1.1 device'.
> Therefore if I enable CONFIG_PCIEASPM, the pci core will automaticly
> disable ASPM (both L0s and L1) on this card.
> I won't be surprised that windows does the same.
>

Even if CONFIG_PCIEASPM compiled in, ASPM code can be disabled by user  
with pcie_aspm=off option, leaving BIOS-enabled L0s on.

-Jussi


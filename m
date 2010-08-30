Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0H3H0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 03:26:30 -0400
Received: from fw2.winet.de ([84.17.96.48]:59876 "EHLO fw2.winet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab0H3H02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 03:26:28 -0400
Message-ID: <4C7B5601.5060505@auerswald.de>
Date: Mon, 30 Aug 2010 08:56:01 +0200
From: =?ISO-8859-1?Q?Wolfgang_M=FCes?= <wolfgang.mues@auerswald.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.7) Gecko/20100713 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Ryan Mallon <ryan@bluewatersys.com>
CC: Chris Ball <cjb@laptop.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <avictor.za@gmail.com>, <akpm@linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/7] mmc: at91_mci: fix pointer errors
References: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com> <20100827193303.GB23079@void.printf.net> <4C7AD3A0.40607@bluewatersys.com>
In-Reply-To: <4C7AD3A0.40607@bluewatersys.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 29.08.2010 23:39, schrieb Ryan Mallon:
> I see this is already applied, but why all the type trickery here? Why
> not just:
>
> 	memcpy(dmabuf, sgbuffer, amount);
> 	dmabuf += amount / sizeof(dmabuf);

Because this is wrong?

Maybe you mean sizeof(*dmabuf)?

The exact style of the bug fix is not important, it's important that 
it's fixed.

best regards

i. A. Wolfgang Muees

Hardware-Entwicklung
Leiter Pruefen & Layout
-- 
Auerswald Gesellschaft fuer Datensysteme mbH

Phone: +49 5306-9219-562
Fax:   +49 5306-9200-94
--------------------------------------------------------------
Auerswald Gesellschaft fuer Datensysteme mbH,
Vor den Grashoefen 1, 38162 Cremlingen

Registriert beim AG Braunschweig HRB 7499
Geschäftsführer: Dipl-Ing. Gerhard Auerswald

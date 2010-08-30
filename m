Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab0H3HJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 03:09:50 -0400
Received: from fw2.winet.de ([84.17.96.48]:59269 "EHLO fw2.winet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab0H3HJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 03:09:48 -0400
Message-ID: <4C7B54F9.6090200@auerswald.de>
Date: Mon, 30 Aug 2010 08:51:37 +0200
From: =?ISO-8859-1?Q?Wolfgang_M=FCes?= <wolfgang.mues@auerswald.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.7) Gecko/20100713 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, <akpm@linux-foundation.org>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <avictor.za@gmail.com>
Subject: Re: [PATCH 1/7] mmc: at91_mci: fix pointer errors
References: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com> <20100827193303.GB23079@void.printf.net> <20100827193457.GC23079@void.printf.net>
In-Reply-To: <20100827193457.GC23079@void.printf.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 27.08.2010 21:34, schrieb Chris Ball:
> On Fri, Aug 27, 2010 at 08:33:03PM +0100, Chris Ball wrote:
>> Looks like only the first half of this patch was applied?  The
>> kunmap_atomic() line is still present as before in Linus' tree.

It was argued that the kunmap_atomic() will truncate the pointer to the 
start of the page anyway, so the subtraction is not needed.

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

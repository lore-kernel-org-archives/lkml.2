Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab0HJPTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 11:19:34 -0400
Received: from 70.mail-out.ovh.net ([91.121.185.63]:36759 "HELO
	70.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932236Ab0HJPT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 11:19:27 -0400
Message-ID: <4C616DF9.1070309@example.com>
Date: Tue, 10 Aug 2010 17:19:21 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-acpi@vger.kernel.org
Subject: Re: BUG: scheduling while atomic: swapper/0/0x10000002
References: <20100810142951.GA7156@arch.tripp.de>
In-Reply-To: <20100810142951.GA7156@arch.tripp.de>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 7924927969963700553
X-Ovh-Remote: 95.49.243.143 (afjj143.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.08.2010 16:29, Markus Trippelsdorf wrote:

> This bug already has two patches available to fix it:
>
> http://lkml.org/lkml/2010/8/6/672
> https://patchwork.kernel.org/patch/113092/

None of them works for me. I do:

cat patch.txt | patch -p1

And get:

aapi205:/usr/src/linux# cat ../smp-bug.txt | patch -p1
patching file include/acpi/platform/aclinux.h
Hunk #1 FAILED at 152.
1 out of 1 hunk FAILED -- saving rejects to file 
include/acpi/platform/aclinux.h.rej

Help me please.

Regards,

Piotr Hosowicz

-- 
Zatrzymuje siê samochód na sejmowym parkingu. Podchodzi do niego 
ochroniarz i mówi:
- Pan tu parkuje?! Tu Sejm ... Ministrowie, politycy, pos³owiei ...
- Dziêki, w³±czê alarm.
NP: Peter Green Splinter Group - There's A River
NB: 2.6.35-git9

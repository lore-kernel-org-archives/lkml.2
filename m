Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661Ab0HGN3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 09:29:50 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:53857 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753213Ab0HGN3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 09:29:49 -0400
Message-ID: <4C5D5FC7.4070706@example.com>
Date: Sat, 07 Aug 2010 15:29:43 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: The horror is over, but I deleted and forgot some lines - please
 help
References: <4C5AD674.30908@example.com>
In-Reply-To: <4C5AD674.30908@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6902047905837248792
X-Ovh-Remote: 83.6.193.216 (abbd216.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.08.2010 17:19, Piotr Hosowicz wrote:
> Hello,
>
> I git-synchronized linux kernel source but it failed to build. I
> discovered that the problem is in sound/pci/hda/hda_codec.c . There was
> some git specific line of text, so I just deleted it and some other two
> lines. It failed again because one of the lines that I just deleted
> contained trailing { brace, closing for statement as far as I remember.
>
> Can somebody remind me what had I deleted at first? And how to spot such
> situations in the future? I thought that I could write a script to
> search and i.e. grep *.c files in the source to catch such coliding
> places. But I don't know what should I search.

Hello,

Nobody can remind me? What is usually written to the source files when 
git failed to sync some files cleanly? I've just built fresh kernel, but 
it didn't fail. Or maybe I could provoke this error some way and see 
what it writes? I'd like to create a script which I would run after git 
pull to search for such files.

Regards,

Piotr Hosowicz

-- 
Z Allegro: PRZEDMIOTEM AUKCJI JEST NOKIA 6210, ODDA£EM JA SPEC-
JALISCIE DO WGRANIA JAKIEGOS SOFTU Z NOWYMI BAJERAMI, NO I MAM
BAJER NA WY¦WIETLACZU W POSTACI NAPISU "CONTACT SERVICE".
NP: Peter Green Splinter Group - Tribal Dance
NB: 2.6.35-20100807-1405+

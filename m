Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab0HNW6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 18:58:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757216Ab0HNW6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 18:58:23 -0400
Message-ID: <4C671F8C.3090203@suse.cz>
Date: Sun, 15 Aug 2010 00:58:20 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: R_ARM_REL32 relocation support
References: <34780qy39a4uj093a4y> <1280993763-15254-1-git-send-email-olof@lixom.net> <19546.31437.994840.466509@pilspetsen.it.uu.se> <20100814114428.GA25336@jirafa.cyrius.com> <4C671CDB.7070707@suse.cz>
In-Reply-To: <4C671CDB.7070707@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 15.8.2010 00:46, Michal Marek napsal(a):
> Dne 14.8.2010 13:44, Martin Michlmayr napsal(a):
>> * Mikael Pettersson <mikpe@it.uu.se> [2010-08-05 10:48]:
>>> Michal Marek's patch(*) to use -fno-dwarf2-cfi-asm already exists
>>> and is IMO the correct solution in that it addresses the cause
>>> of the problem rather than its symptoms.
>>>
>>> (*) http://lkml.org/lkml/2010/7/26/154
>>
>> I cannot find Michal's patch in mainline or in RMK's patch tracker.
>> Michal, did you submit your patch to
>> http://www.arm.linux.org.uk/developer/patches/ ?
> 
> No, I didn't. I didn't even know about this site. I'll do it in a minute.

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6328/1

Michal

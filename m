Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab1GGNyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:54:35 -0400
Received: from 13.mo1.mail-out.ovh.net ([178.33.253.128]:60035 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752477Ab1GGNya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:54:30 -0400
X-Greylist: delayed 2396 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jul 2011 09:54:30 EDT
Message-ID: <4E15B840.3080701@example.com>
Date: Thu, 07 Jul 2011 15:44:32 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Icedove/3.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Fwd: Re: Today's Linux Next failed to even start building, I must
 have done something wrong
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 13276893177928708376
X-Ovh-Remote: 178.36.17.0 (178-36-17-0.adsl.inetia.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I post once again, my mailer did something wrong.

-------- Original Message --------
Subject: Re: Today's Linux Next failed to even start building, I must 
have done something wrong
Date: Thu, 07 Jul 2011 15:28:44 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
To: piotr@hosowicz.com

On 07.07.2011 14:47, Piotr Hosowicz wrote:
> Hello,
>
> I'm not sure - which base source tree should I take to apply the patch?
> I fail for now with building witch Debian make-kpkg with messages:
>
> # ...
> make ARCH=x86_64 prepare
> make[2]: Wejście do katalogu `/usr/src/linux-3.0-rc6-nx-20110707'
> scripts/kconfig/conf --silentoldconfig Kconfig
> make[2]: Opuszczenie katalogu `/usr/src/linux-3.0-rc6-nx-20110707'
> make[2]: Wejście do katalogu `/usr/src/linux-3.0-rc6-nx-20110707'
> CHK include/linux/version.h
> UPD include/linux/version.h
> CHK include/generated/utsrelease.h
> UPD include/generated/utsrelease.h
> CC kernel/bounds.s
> GEN include/generated/bounds.h
> CC arch/x86/kernel/asm-offsets.s
> In file included from include/linux/sched.h:64:0,
> from arch/x86/kernel/asm-offsets.c:9:
> include/linux/mm_types.h:74:15: error: duplicate member ‘_count’
> make[3]: *** [arch/x86/kernel/asm-offsets.s] Błąd 1
> make[2]: *** [prepare0] Błąd 2
> make[2]: Opuszczenie katalogu `/usr/src/linux-3.0-rc6-nx-20110707'
> make[1]: *** [debian/stamp/conf/kernel-conf] Błąd 2
> make[1]: Opuszczenie katalogu `/usr/src/linux-3.0-rc6-nx-20110707'
> make: *** [debian/stamp/conf/minimal_debian] Błąd 2
> Failed to create a ./debian directory: Nie ma takiego pliku ani katalogu
> at /usr/bin/make-kpkg line 984.
>
> Please help me.

Solved, thanks to Christoph Lameter in thread "Build issue with linux
next. duplicate member _count in mm_types.h".

-- 
"Chcemy waszego dobra!" - powiedział lider
socjaldemokratów. Zaniepokojeni obywatele
zaczeli ukrywać swoje dobra w bezpiecznych
miejscach.
NP: Nemo -
NB: 3.0.0-rc6


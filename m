Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab1GGOte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:49:34 -0400
Received: from 14.mo1.mail-out.ovh.net ([178.32.97.215]:55594 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756745Ab1GGOtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:49:31 -0400
X-Greylist: delayed 7327 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jul 2011 10:49:31 EDT
Message-ID: <4E15C59E.5000900@example.com>
Date: Thu, 07 Jul 2011 16:41:34 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Icedove/3.0.11
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: Build issue with linux next. duplicate member _count in mm_types.h
References: <4E143120.2020501@cam.ac.uk> <alpine.DEB.2.00.1107060933460.17202@router.home> <4E15AF1C.7080103@example.com> <alpine.DEB.2.00.1107070841500.17376@router.home> <4E15B945.5060805@example.com> <alpine.DEB.2.00.1107070908320.17929@router.home>
In-Reply-To: <alpine.DEB.2.00.1107070908320.17929@router.home>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 14240100548576375085
X-Ovh-Remote: 178.36.17.0 (178-36-17-0.adsl.inetia.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -230
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.07.2011 16:09, Christoph Lameter wrote:
> On Thu, 7 Jul 2011, Piotr Hosowicz wrote:
>
>> I attach it. Your patch seems to had worked, I finish making the package.
>
> I do not see anything remarkable in the config file.
>
> Which compiler version are you using?
>
> Mine is:
>
> christoph@oldy:~$ gcc --version
> gcc (Ubuntu/Linaro 4.4.4-14ubuntu5) 4.4.5
> Copyright (C) 2010 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions. There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
> PURPOSE.

Mine is:

aapi205:~# gcc --version
gcc (Debian 4.6.0-10) 4.6.1 20110526 (prerelease)
Copyright (C) 2011 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

-- 
Nie pytaj co rz±d mo¿e zrobiæ dla ciebie. Pytaj, jak mo¿esz temu zapobiec.
NP: Nemo -
NB: 3.0.0-rc6-next-20110707

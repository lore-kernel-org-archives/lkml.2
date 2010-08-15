Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab0HOP5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:57:09 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:44853 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757839Ab0HOP5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:57:07 -0400
Message-ID: <4C67D60D.9050903@example.com>
Date: Sun, 15 Aug 2010 13:57:01 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Hagen Paul Pfeifer <hagen@jauu.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioctl definition - has it changed recently?
References: <4C67023D.6050603@example.com> <4C670478.4040609@example.com> <20100814212007.GA26128@nuttenaction>
In-Reply-To: <20100814212007.GA26128@nuttenaction>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 15424265774802694414
X-Ovh-Remote: 83.24.76.41 (dmu41.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I resend, I dont know why it didn't appear on LKML. Thanks.

Piotr Hosowicz

On 14.08.2010 23:20, Hagen Paul Pfeifer wrote:
> * Piotr Hosowicz | 2010-08-14 23:02:48 [+0200]:
>
>> The latest driver is here:
>>
>> ftp://download.nvidia.com/XFree86/Linux-x86_64/256.44/
>>
>> To unpack execute it with --extract-only option.
>
> remove line 426 of kernel/nv.c:
>
>      .ioctl     = nv_kern_ioctl,
>
>
> ... and try again. ;)

Sorry, I was wrong when I wrote yesterday. I tried again and it works. 
Thank you a lot. It will be my standard way to deal with this.

Cheers,

Piotr Hosowicz

-- 
Skarga z 1983 roku: Zamiast 3 kg cukru ekspedientka sprzeda³a
mi 3 kg mrówek faraona (podpis nieczytelny). Dopisek kierowni-
czki: Klient by³ w stanie nietrze¼wym.
NP: Peter Green Splinter Group - Big Change Is Gonna Come
NB: 2.6.35-git16

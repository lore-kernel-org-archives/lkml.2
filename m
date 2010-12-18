Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab0LRQgx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 11:36:53 -0500
Received: from 29.mail-out.ovh.net ([87.98.216.213]:50874 "HELO
	29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753147Ab0LRQgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 11:36:52 -0500
Message-ID: <4D0CE320.4070205@example.com>
Date: Sat, 18 Dec 2010 17:36:48 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101211 Icedove/3.0.11
MIME-Version: 1.0
To: dl8bcu@dl8bcu.de, linux-kernel@vger.kernel.org
Subject: Re: Why is networking GIT refusing me?
References: <4D0CDB28.8090809@example.com> <20101218163035.GA1127@ds20.borg.net>
In-Reply-To: <20101218163035.GA1127@ds20.borg.net>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 16366362522495775164
X-Ovh-Remote: 83.6.195.8 (abbf8.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.12.2010 17:30, Thorsten Kranzkowski wrote:
> On Sat, Dec 18, 2010 at 05:02:48PM +0100, Piotr Hosowicz wrote:
>> Hello,
>>
>> I tried to update my Linux tree with the newest networking source vand
>> tried to run:
>>
>> git remote add networking
>> master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master
>
> you probably want to use
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
> for public, read only access.

Yes, Kyle just told me, I'll build again right away.

Regards,

Piotr Hosowicz

-- 
Z cyklu "Uroki demokracji", czyli pytania i odpowiedzi w teledurniejach:
- W którym kraju znajduje siê Mount Everest?
- Hm, to nie Szkocja, prawda?
NP: Peter Green Splinter Group - Heart Of Stone
NB: 2.6.37-rc6-20101218-1641-pzti+

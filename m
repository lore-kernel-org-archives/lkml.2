Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0HZPUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 11:20:21 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:45328 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753991Ab0HZPUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 11:20:19 -0400
Message-ID: <4C76862D.5050703@example.com>
Date: Thu, 26 Aug 2010 17:20:13 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
CC: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Which kernel.org WWW is the master server?
References: <4C6D4864.2040002@example.com> <alpine.LRH.2.00.1008261536290.2372@twin.jikos.cz> <4C7683D3.5090500@nets.rwth-aachen.de>
In-Reply-To: <4C7683D3.5090500@nets.rwth-aachen.de>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 9668946926827893158
X-Ovh-Remote: 95.49.238.22 (afje22.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.08.2010 17:10, Arnd Hannemann wrote:
> Am 26.08.2010 15:37, schrieb Jiri Kosina:
>> On Thu, 19 Aug 2010, Piotr Hosowicz wrote:
>>
>>
>>> I wrote a simple python script that tells me that a new kernel version
>>> appeared. The problem is that it is based exactly on this what appears on the
>>> webpage so sometimes it resolves the server IP that the version has changed,
>>> despite the fact that it is not true. Which server is the master server?
>>>
>> I guess that simply running
>>
>> 	finger @kernel.org
>>
>> will give you exactly the information you are looking for which much less
>> pain of connecting to www server, parsing html, etc.
>>
>
> Not sure if this is still accurate:
>
>> Aug 21, 2003: Please don't use *finger.kernel.org* for any sort of
>> automatic monitoring. The number of automatic bots hitting this port
>> is causing the finger daemon to shut down more often than not. The
>> same information is available from
>> http://www.kernel.org/kdist/finger_banner
>> <http://kernel.org/kdist/finger_banner>.

Moreover it is written as the above.

Regards,

Piotr Hosowicz

-- 
"Bardzo fajna firma, tylko czasami nie p³aci. Do jej g³ównych
zalet nale¿±: ekspres ci¶nieniowy (ale tylko na jednym z piê-
ter) oraz fajne widoki z salki konferencyjnej. No i jakie¶
pó³ roku temu odesz³o 90% pracowników dzia³u IT, ale mo¿e nie
mieli racji ;)"
NP: Peter Green Splinter Group - I Can't Help Myself
NB: 2.6.36-rc2-git4

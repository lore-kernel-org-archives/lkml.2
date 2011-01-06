Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab1AFRLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:11:11 -0500
Received: from 27.mail-out.ovh.net ([91.121.30.210]:49093 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753042Ab1AFRLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:11:09 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2011 12:11:09 EST
Message-ID: <4D25F611.9040802@example.com>
Date: Thu, 06 Jan 2011 18:04:17 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: GIT question - am I doing it correctly?
References: <4D1B6066.9000701@example.com> <20110103134807.GA3911@tiehlicka.suse.cz>
In-Reply-To: <20110103134807.GA3911@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 17731516158631637261
X-Ovh-Remote: 83.24.90.218 (dni218.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.01.2011 14:48, Michal Hocko wrote:
> On Wed 29-12-10 17:23:02, Piotr Hosowicz wrote:
>> Hello,
>
> Hi,
>
>>
>> Everytime I git pull tyhe Linus' sources but before I build I apply
>> Peter Zijlstra's fixes, Takashi Iwai's sources and Dave Miller's
>> sources. The sequence is:
>>
>> # the Linus' sources
>> git pull
>>
>> # external sources
>> git remote add some_name git://some_URL.git
>>
>> # update
>> git remote update
>>
>> Then configure and I build. I noticed that especially Peter's
>> git-update very quickly, not as long as they did before.
>>
>> Is my procedure correct? I am new to GIT.
>
> What do you want to achieve?

I would like to have everything from Linus tree + additions from mmotm 
for example. How to do it? I tried to read from the URL you gave me, but 
I bet I don't understand something. How should I do it?

Regards,

Piotr Hosowicz

-- 
Z cyklu "Uroki demokracji", czyli pytania i odpowiedzi w teledurniejach:
- Jak d³ugo trwa³a wojna sze¶ciodniowa miêdzy Izraelem a Egiptem?
- (po d³u¿szym namy¶le): Czterna¶cie dni.
NP: Peter Green Splinter Group - Big Change Is Gonna Come
NB: 2.6.37

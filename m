Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab0IYReT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 13:34:19 -0400
Received: from 26.mail-out.ovh.net ([91.121.27.225]:56116 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753597Ab0IYReS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 13:34:18 -0400
Message-ID: <4C9E3296.90808@example.com>
Date: Sat, 25 Sep 2010 19:34:14 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [00/80] 2.6.35.6 stable review
References: <20100924162706.GA7381@kroah.com> <4C9E2801.4020609@example.com> <20100925172459.GA2208@suse.de>
In-Reply-To: <20100925172459.GA2208@suse.de>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 3645382424429097360
X-Ovh-Remote: 83.6.189.13 (abaz13.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.09.2010 19:24, Greg KH wrote:
> On Sat, Sep 25, 2010 at 06:49:05PM +0200, Piotr Hosowicz wrote:
>> On 24.09.2010 18:27, Greg KH wrote:
>>
>>> This is the start of the stable review cycle for the 2.6.35.6 release.
>>> There are 80 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let us know.  If anyone is a maintainer of the proper subsystem, and
>>> wants to add a Signed-off-by: line to the patch, please respond with it.
>>>
>>> Responses should be made by Sunday September 26, 17:00:00 UTC
>>> Anything received after that time might be too late.
>>
>> nouveau graphics driver does not work at all. I submitted full data a few
>> days ago.
>
> Was that with .5 or is this something new for .6?  And sorry if I missed
> this, for some reason I thought the problem was with the nvidia driver.
>
> If it showed up in .5 can you bisect to see what the problem patch was?

And in this case I'm afraid that I cannot bisect, because there is no 
good state, that driver failed always for me.

-- 
Siedzi wyfiokowana Jola i gada. Przez 15 minut czy wiêcej uczy
obywateli,  jak je¶æ bezê.  ¯e bezy  nie mo¿na  kroiæ  no¿em i
widelcem, bo mo¿e trysn±æ.  ¯e trzeba zdj±æ kapelusik od bezy.
I to jest kurwa program pierwszej damy!
NP: Peter Green Splinter Group - Say That You Want To
NB: 2.6.35.6-rc1

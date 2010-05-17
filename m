Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab0EQHvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 03:51:11 -0400
Received: from 68.mail-out.ovh.net ([91.121.185.69]:36092 "HELO
	68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754339Ab0EQHvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 03:51:09 -0400
Message-ID: <4BF0F563.9050802@example.com>
Date: Mon, 17 May 2010 09:50:59 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: sboyce@blueyonder.co.uk
CC: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: General questiin about SYSFS
References: <4BF05EC9.6070102@blueyonder.co.uk> <4BF0AA6C.1050102@example.com> <4BF0F334.8090108@blueyonder.co.uk>
In-Reply-To: <4BF0F334.8090108@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 17683383937984721389
X-Ovh-Remote: 83.6.195.181 (abbf181.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-Ovh-Tracer-Id: 17773174455205458200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.05.2010 09:41, Sid Boyce wrote:
> On 17/05/10 03:31, Piotr Hosowicz wrote:
>> On 16.05.2010 23:08, Sid Boyce wrote:
>>> As the message says, you have to change all instances of SSYSFS to ATTR
>>>    in the rules files in /etc/udev/rules.d to stop those messages
>>> appearing on boot up.
>>
>> Ok, forget my next question - I risked breaking things and made a plain
>> search and replace, reboot, things seem to work, no errors. I also had
>> to change BUS to SUBSYSTEM.
>>
>> Regards,
>>
>> Piotr Hosowicz
>>
>
> I forgot to mention the BUS to SUBSYSTEM  change, but it was obvious
> when looking at the messages. One other I've seen (on openSUSE 11.3),
> /etc/modprobe.conf deprecated, so I've moved it out of /etc and also
> changed files in /etc/modprobe.d from xxxxxxx to xxxxxxx.conf. It all
> helps keep the noise down.
> No problems, I have been running with the modified files for some months.

I am on Debian and modprobe.conf is not deprecated as far as I know.

Regards,

Piotr Hosowicz


-- 
Polsat: ogl±dasz z rodzink± reklamy, a tu nagle - trach! - film!
NP: Slash - Ghost (Feat. Ian Astbury)
NB: 2.6.34

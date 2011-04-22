Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1DVMxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:53:21 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:65098 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851Ab1DVMxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:53:17 -0400
Message-ID: <4DB17A3B.3060609@blueyonder.co.uk>
Date: Fri, 22 Apr 2011 13:53:15 +0100
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8 ThunderBrowse/3.3.5
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] misc: Driver for Silicon Labs Si570 and compatibles
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=RQ36K_f0x-kA:10 a=jP4ZM9dVWk4A:10 a=3NElcqgl2aoA:10 a=k1j_C7plYBUA:10 a=8nJEP1OIZ-IA:10 a=CfAdl1vy_98PchHglTcA:9 a=ZqaCy0LOAm4tKVGwBowA:7 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck wrote:
Depends. In our case, turns out the devices consuming the clock
have user mode drivers. Lots of history there, but the chip vendors
provide those user mode drivers, and the teams responsible for
integrating the drivers decided to not rewrite it to kernel mode drivers.
Also, for special purposes such as margining, it is necessary to control
the clock from userspace. So, for our use case, I need the user-visible
interface. I _don't_ need the kernel interface, at least not right now,
which is why I did not add it.

Browsing through the web, it seems the chip is somewhat popular with
Amateur Radio. No idea if it would ever be controlled for such a purpose
from Linux, but if so, it would also require a user configurable frequency.

If there is a better place for such a driver than misc, please let me know.

Thanks,
Guenter
=============================================================================
Support for these devices included in several Amateur radio programs 
tend to differ greatly which means reinventing the wheel in most of them.
Programs like Linrad, sdr-shell, quisk, lysdr, ghpsdr3, etc.
It's a small addition to the kernel that would significantly help in the 
development of software for the myriad of SDR (Software Defined Radio) 
designs based on this chip family.
I have 5 Amateur Radio transceivers using this chip and 2 more soon to 
be added.
They are all open hardware heavily reliant on Linux.
The addition of UAC2 (USB Audio Class 2) kernel support has helped our 
SDR hardware design efforts significantly.
I and the rest of the Linux SDR community would be happy to see it included.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

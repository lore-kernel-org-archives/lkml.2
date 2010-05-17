Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab0EQCbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 22:31:16 -0400
Received: from 68.mail-out.ovh.net ([91.121.185.69]:42836 "HELO
	68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752289Ab0EQCbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 22:31:13 -0400
Message-ID: <4BF0AA6C.1050102@example.com>
Date: Mon, 17 May 2010 04:31:08 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: sboyce@blueyonder.co.uk
CC: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: General questiin about SYSFS
References: <4BF05EC9.6070102@blueyonder.co.uk>
In-Reply-To: <4BF05EC9.6070102@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 12280753234180076013
X-Ovh-Remote: 83.6.195.181 (abbf181.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-Ovh-Tracer-Id: 12369699327170277656
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.05.2010 23:08, Sid Boyce wrote:
> As the message says, you have to change all instances of SSYSFS to ATTR
>   in the rules files in /etc/udev/rules.d to stop those messages
> appearing on boot up.

Ok, forget my next question - I risked breaking things and made a plain 
search and replace, reboot, things seem to work, no errors. I also had 
to change BUS to SUBSYSTEM.

Regards,

Piotr Hosowicz

-- 
"Bardzo fajna firma, tylko czasami nie p³aci. Do jej g³ównych
zalet nale¿±: ekspres ci¶nieniowy (ale tylko na jednym z piê-
ter) oraz fajne widoki z salki konferencyjnej. No i jakie¶
pó³ roku temu odesz³o 90% pracowników dzia³u IT, ale mo¿e nie
mieli racji ;)"
NP: Slash - Ghost (Feat. Ian Astbury)
NB: 2.6.34

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab0EQBwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 21:52:13 -0400
Received: from 68.mail-out.ovh.net ([91.121.185.69]:58347 "HELO
	68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751945Ab0EQBwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 21:52:12 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 May 2010 21:52:11 EDT
Message-ID: <4BF09FB6.7030704@example.com>
Date: Mon, 17 May 2010 03:45:26 +0200
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
X-Ovh-Tracer-Id: 11508948849420235245
X-Ovh-Remote: 83.6.195.181 (abbf181.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-Ovh-Tracer-Id: 11597613467184623896
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.05.2010 23:08, Sid Boyce wrote:
> As the message says, you have to change all instances of SSYSFS to ATTR
>   in the rules files in /etc/udev/rules.d to stop those messages
> appearing on boot up.

Just plain search and replace ATTR for SYSFS?

Thanks, regards,

Piotr Hosowicz

-- 
Z cyklu "Uroki demokracji", czyli pytania i odpowiedzi w teledurniejach:
- Któr± postaæ ubran± tylko w przepaskê na biodrach i hu¶taj±c± siê na 
lianach gra³ Johnny Weissmuller?
- Jezusa.
NP: Patrick O'Hearn - Approaching Summit
NB: 2.6.34-rc7-git9

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab2CNLds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:33:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54042 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab2CNLdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:33:45 -0400
Message-ID: <4F6081C3.4070905@mvista.com>
Date: Wed, 14 Mar 2012 15:32:19 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Gupta, Ajay Kumar" <ajay.gupta@ti.com>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [PATCH] arm:da850: register musb device
References: <1331651015-32586-1-git-send-email-prakash.pm@ti.com> <4F5F7F91.8010301@mvista.com> <A73F36158E33644199EB82C5EC81C7BC3178406C@DBDE01.ent.ti.com>
In-Reply-To: <A73F36158E33644199EB82C5EC81C7BC3178406C@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 14-03-2012 10:16, Manjunathappa, Prakash wrote:

>>> Properly set up the OTG mode thru the CFGCHIP2 register, enable the
>>> USB0_DRVVBUS pin,

>>      I don't see where you are enabling it.

> Yes, I will correct the message.

>>> and finally register the MUSB platform device.

    Also, you're registering the MUSB device for DA850/OMAP-L138 EVM board, 
not the whole DA850/OMAP-L138 SoC, so that should be reflected in the subject.

>>> Signed-off-by: Ajay Kumar Gupta<ajay.gupta@ti.com>
>>> Signed-off-by: Manjunathappa, Prakash<prakash.pm@ti.com>

WBR, Sergei

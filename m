Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab0KVUMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 15:12:45 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:42669
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755512Ab0KVUMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 15:12:44 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz98dNzz1202hzzz2dh2a8h637h668h67dh685h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
Message-ID: <4CEACEB1.8020004@freescale.com>
Date: Mon, 22 Nov 2010 14:12:33 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
References: <20101118163321.GA2723@suse.de>	<4CE5562B.8080604@freescale.com>	<20101118165136.GA3103@suse.de>	<4CE55ACB.80207@freescale.com>	<20101118171856.GA4283@suse.de>	<4CE5647F.5000203@freescale.com>	<20101118175832.GA4931@suse.de>	<4CE58005.7040308@freescale.com>	<20101118200230.GA25715@suse.de>	<4CE58736.4090703@freescale.com>	<20101118201035.GA26287@suse.de>	<4CE58FE5.3010502@freescale.com> <20101118205647.677404ec@lxorguk.ukuu.org.uk> <4CEA9B00.1000804@freescale.com>
In-Reply-To: <4CEA9B00.1000804@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Nov 2010 20:13:42.0437 (UTC) FILETIME=[C23CCD50:01CB8A81]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> Can you elaborate on that?  What is the "required method"?  My driver is mostly
> working now, but I have to supply the command-line "console=ttyEHV73" in order
> for the login prompt to show up.  Unfortunately, there's no way for the boot
> loader to know that the primary byte channel for stdout is #73, so I need a way
> for the driver to tell the kernel this.

Never mind .. I got it working.  For some reason, it took a while for me to get
add_preferred_console() working.

-- 
Timur Tabi
Linux kernel developer at Freescale


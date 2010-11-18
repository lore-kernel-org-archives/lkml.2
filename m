Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360Ab0KRUng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:43:36 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:16364
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757902Ab0KRUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:43:35 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzzz2dh2a8h637h668h67dh685h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
Message-ID: <4CE58FE5.3010502@freescale.com>
Date: Thu, 18 Nov 2010 14:43:17 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
References: <20101118163321.GA2723@suse.de> <4CE5562B.8080604@freescale.com> <20101118165136.GA3103@suse.de> <4CE55ACB.80207@freescale.com> <20101118171856.GA4283@suse.de> <4CE5647F.5000203@freescale.com> <20101118175832.GA4931@suse.de> <4CE58005.7040308@freescale.com> <20101118200230.GA25715@suse.de> <4CE58736.4090703@freescale.com> <20101118201035.GA26287@suse.de>
In-Reply-To: <20101118201035.GA26287@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 20:44:20.0779 (UTC) FILETIME=[605287B0:01CB8761]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> > One last question.  If I create multiple TTY devices, how do I tell the kernel
>> > which one should be used for the console?

> On the command line.

Is there a way to do it in the driver itself?  Getting the boot loader to
identify the specific byte channel for stdout isn't trivial.  It'd be nice if
the driver could tell the tty layer, "BTW, this use this for the default console".

-- 
Timur Tabi
Linux kernel developer at Freescale


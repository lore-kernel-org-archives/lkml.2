Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531Ab0KRUGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:06:22 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:49789
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756258Ab0KRUGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:06:21 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz98dNzz1202hzzz2dh2a8h637h668h67dh685h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
Message-ID: <4CE58736.4090703@freescale.com>
Date: Thu, 18 Nov 2010 14:06:14 -0600
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
References: <20101118153912.GA1443@suse.de> <4CE54E40.9040503@freescale.com> <20101118163321.GA2723@suse.de> <4CE5562B.8080604@freescale.com> <20101118165136.GA3103@suse.de> <4CE55ACB.80207@freescale.com> <20101118171856.GA4283@suse.de> <4CE5647F.5000203@freescale.com> <20101118175832.GA4931@suse.de> <4CE58005.7040308@freescale.com> <20101118200230.GA25715@suse.de>
In-Reply-To: <20101118200230.GA25715@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 20:07:17.0018 (UTC) FILETIME=[32DB87A0:01CB875C]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Does that work for you?  Looks fine to me :)

Ok!

> But again, you really should get the driver model portion right...

I'll do that.

One last question.  If I create multiple TTY devices, how do I tell the kernel
which one should be used for the console?

-- 
Timur Tabi
Linux kernel developer at Freescale


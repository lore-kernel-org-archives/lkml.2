Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757Ab0KRQhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:37:07 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:46313
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757831Ab0KRQhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:37:05 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz98dNzz1202hzzz2dh2a8h637h668h67dh685h66h)
X-Spam-TCS-SCL: 5:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
Message-ID: <4CE5562B.8080604@freescale.com>
Date: Thu, 18 Nov 2010 10:36:59 -0600
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
References: <4CE44B1B.9040709@freescale.com> <20101117215147.GA26792@suse.de> <4CE452CD.3050001@freescale.com> <20101117221903.GA4066@suse.de> <4CE45A4E.70308@freescale.com> <20101118022434.GA9833@suse.de> <4CE546C5.8060401@freescale.com> <20101118153912.GA1443@suse.de> <4CE54E40.9040503@freescale.com> <20101118163321.GA2723@suse.de>
In-Reply-To: <20101118163321.GA2723@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 16:38:02.0339 (UTC) FILETIME=[F7AF8B30:01CB873E]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> If all you want is a tty driver, then just write a tty driver.  No need
> for character device nodes or any of that other stuff.  Just assign
> minor numbers to the device, create it, attach it to the tty core, and
> away you go.

What I would like to do is have some control over the name or minor number of
the /dev entry.

> I think you are going to have to show code here to get any kind of a
> better response out of me as I don't think we are understanding each
> other here, sorry.

I'll have to email it to you directly, since it's not authorized for public
distribution just quite yet.

-- 
Timur Tabi
Linux kernel developer at Freescale


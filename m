Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab2GBSTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:19:23 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:10985 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861Ab2GBSTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:19:22 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1202h1082kzzz2dh2a8h668h839hd25he5bhf0ah)
Message-ID: <4FF1E625.9040403@freescale.com>
Date: Mon, 2 Jul 2012 13:19:17 -0500
From: Timur Tabi <b04825@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: "Kokoris, Ioannis" <ioannis.kokoris@siemens-enterprise.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] P1021: set IReady in QE Microcode Upload
References: <026483A88B848047A08C3F03E20822D0267B1F4A55@MCHP058A.global-ad.net> <4EBD4FB8.2020406@freescale.com> <026483A88B848047A08C3F03E20822D0267B1F4BDB@MCHP058A.global-ad.net> <CAOZdJXXOrSaUgynqu+CL64SnivtOWHBDMcJK9Fh000M_JBK58Q@mail.gmail.com> <DF5BDBFF-A726-4E1C-832E-EF2629F60DC9@kernel.crashing.org> <0154F680-D9F4-4CE1-BF5E-11884AD0ED4A@freescale.com> <AC087E7A-B7BC-43E5-948F-68AEB8251FD3@kernel.crashing.org> <4F63652C.3050108@freescale.com> <9508ABD9-607F-4D41-A169-743ADE625F4A@kernel.crashing.org>
In-Reply-To: <9508ABD9-607F-4D41-A169-743ADE625F4A@kernel.crashing.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
>> > No, I forgot all about it.  I'll try it today, assuming the lone 8323
>> > board in the board farm still works.

> Do you remember if you ever tested this?

Well, I tried to test it.  We have an 83xx board that has a QE UART that
needs firmware uploaded, but I don't know how to connect that QE to an
actual RS232 port.  It needs a riser which I don't think we have.

I can verify that the QE UART driver does not hang which this patch, and
that it appears to still be sending data, but I have no way of knowing for
sure.

-- 
Timur Tabi
Linux kernel developer at Freescale


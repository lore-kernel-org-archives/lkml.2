Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab0CYS6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:58:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47526
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754069Ab0CYS6W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:58:22 -0400
Date: Thu, 25 Mar 2010 11:58:46 -0700 (PDT)
Message-Id: <20100325.115846.00009969.davem@davemloft.net>
To: isdn@linux-pingi.de
Cc: henne@nachtwindheim.de, linux@dominikbrodowski.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] isdn: Cleanup Sections in PCMCIA driver sedlbauer
From: David Miller <davem@davemloft.net>
In-Reply-To: <201003251313.18144.isdn@linux-pingi.de>
References: <1269518732-4515-1-git-send-email-henne@nachtwindheim.de>
	<201003251313.18144.isdn@linux-pingi.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karsten Keil <isdn@linux-pingi.de>
Date: Thu, 25 Mar 2010 13:13:18 +0100

> On Donnerstag, 25. März 2010 13:05:29 Henrik Kretzschmar wrote:
>> Compiling this driver gave a section mismatch,
>> so I reviewed the init/exit paths of the driver
>> and made the correct changes.
>> 
>> WARNING: drivers/isdn/hisax/built-in.o(.text+0x558d6): Section mismatch
>> in reference from the function sedlbauer_config() to the function
>> .devinit.text:hisax_init_pcmcia()
>> The function sedlbauer_config() references
>> the function __devinit hisax_init_pcmcia().
>> This is often because sedlbauer_config lacks a __devinit
>> annotation or the annotation of hisax_init_pcmcia is wrong.
>> 
>> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
> Acked-by: <keil@b1-systems.de>
> 
> Thank you for fixing this.

Thanks for reviewing Karsten.

Please put your proper name in your ACK lines in the
future, they should look just like Signed-off-by: lines.

I fixed this up when committing, thanks again.

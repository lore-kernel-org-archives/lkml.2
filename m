Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab0CYMNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:13:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50118 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab0CYMNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:13:33 -0400
From: Karsten Keil <isdn@linux-pingi.de>
Reply-To: isdn@linux-pingi.de
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: Re: [PATCH 1/4] isdn: Cleanup Sections in PCMCIA driver sedlbauer
Date: Thu, 25 Mar 2010 13:13:18 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.27.45-0.1-default; KDE/4.4.1; x86_64; ; )
Cc: davem@davemloft.net, linux@dominikbrodowski.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1269518732-4515-1-git-send-email-henne@nachtwindheim.de>
In-Reply-To: <1269518732-4515-1-git-send-email-henne@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003251313.18144.isdn@linux-pingi.de>
X-Provags-ID: V01U2FsdGVkX1+YCnOrERXwoBKneQqNHLeZPvm3+NyLWT6wM63
 XEdr0z9cOf9ZNHLJAKRorUO56jLcu/HYXc9G4bCZ45SN0G6x2J
 KIBVJt1qV4vvnlVTIEm05Iw1ME+brPV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag, 25. März 2010 13:05:29 Henrik Kretzschmar wrote:
> Compiling this driver gave a section mismatch,
> so I reviewed the init/exit paths of the driver
> and made the correct changes.
> 
> WARNING: drivers/isdn/hisax/built-in.o(.text+0x558d6): Section mismatch
> in reference from the function sedlbauer_config() to the function
> .devinit.text:hisax_init_pcmcia()
> The function sedlbauer_config() references
> the function __devinit hisax_init_pcmcia().
> This is often because sedlbauer_config lacks a __devinit
> annotation or the annotation of hisax_init_pcmcia is wrong.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: <keil@b1-systems.de>

Thank you for fixing this.
l

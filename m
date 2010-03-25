Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab0CYRT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:19:56 -0400
Received: from isilmar.linta.de ([213.133.102.198]:41856 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752087Ab0CYRTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:19:53 -0400
Date: Thu, 25 Mar 2010 18:02:40 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: Henrik Kretzschmar <henne@nachtwindheim.de>, davem@davemloft.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] isdn: Cleanup Sections in PCMCIA driver sedlbauer
Message-ID: <20100325170240.GB5424@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Karsten Keil <isdn@linux-pingi.de>,
	Henrik Kretzschmar <henne@nachtwindheim.de>, davem@davemloft.net,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <1269518732-4515-1-git-send-email-henne@nachtwindheim.de>
 <201003251313.18144.isdn@linux-pingi.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201003251313.18144.isdn@linux-pingi.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten, will you carry these fixes upstream, or shall I do?

Best,
	Dominik

On Thu, Mar 25, 2010 at 01:13:18PM +0100, Karsten Keil wrote:
> On Donnerstag, 25. März 2010 13:05:29 Henrik Kretzschmar wrote:
> > Compiling this driver gave a section mismatch,
> > so I reviewed the init/exit paths of the driver
> > and made the correct changes.
> > 
> > WARNING: drivers/isdn/hisax/built-in.o(.text+0x558d6): Section mismatch
> > in reference from the function sedlbauer_config() to the function
> > .devinit.text:hisax_init_pcmcia()
> > The function sedlbauer_config() references
> > the function __devinit hisax_init_pcmcia().
> > This is often because sedlbauer_config lacks a __devinit
> > annotation or the annotation of hisax_init_pcmcia is wrong.
> > 
> > Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
> Acked-by: <keil@b1-systems.de>
> 
> Thank you for fixing this.
> l

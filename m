Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab1BTVGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 16:06:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52096 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753468Ab1BTVGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 16:06:09 -0500
Date: Sun, 20 Feb 2011 21:07:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/20] ata_piix: unify code for programming PIO and
 MWDMA timings
Message-ID: <20110220210731.0c774fa7@lxorguk.ukuu.org.uk>
In-Reply-To: <4D617CC8.3020108@ru.mvista.com>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122346.19110.8441.sendpatchset@linux-mhg7.site>
	<4D6118DC.80505@ru.mvista.com>
	<20110220185958.364df4cc@lxorguk.ukuu.org.uk>
	<4D617CC8.3020108@ru.mvista.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     PIO mode is setup by different code, and it takes care of the IORDY 
> setting according to the PIO rules (and it gets called). DMA mode setup should 
> just ignore the IORDY setting as in all other sane drivers.


Well it can't ignore it - but if you mean just keep the bit as is then
that sounds sensible, have to see what the docs say happens if you ever
set MWDMA without IORDY.


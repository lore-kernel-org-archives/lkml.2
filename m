Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0KSRoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:44:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57673 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755658Ab0KSRoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:44:15 -0500
Date: Fri, 19 Nov 2010 17:42:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 19
Message-ID: <20101119174257.58bb8e32@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTik6Aq+kWzpmYckKkV5yVMFPt-J0E7OMM6Rd4ouO@mail.gmail.com>
References: <20101119143207.b2d5731e.sfr@canb.auug.org.au>
	<AANLkTik6Aq+kWzpmYckKkV5yVMFPt-J0E7OMM6Rd4ouO@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 18:40:41 +0100
Zimny Lech <napohybelskurwysynom2010@gmail.com> wrote:

> Salve,
> 
> 2010/11/19 Stephen Rothwell <sfr@canb.auug.org.au>:
> > Hi all,
> >
> > Changes since 20101118:
> 
> This probably should not be available on x86_64
> 
>   BLD FW  drivers/net/wan/wanxlfw.inc
> /bin/sh: as68k: command not found
> /home/test/linux-2.6/drivers/net/wan/wanxlfw.S:39:0: fatal error: when
> writing output to : Broken pipe
> compilation terminated.
> make[4]: *** [drivers/net/wan/wanxlfw.inc] Error 127

If you want to build the wanxl firmware then you need the m68k assembler
for the firmware, so it is right.

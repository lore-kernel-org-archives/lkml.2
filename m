Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1GCMfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 08:35:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55098 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752661Ab1GCMfV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 08:35:21 -0400
Date: Sun, 3 Jul 2011 13:37:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
        Thomas Hellstrom <thomas@tungstengraphics.com>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] gma500: fix compiler warnings and format string
Message-ID: <20110703133732.4e2ed436@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LNX.2.00.1107030914100.16316@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107030914100.16316@swampdragon.chaosbits.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jul 2011 09:16:13 +0200 (CEST)
Jesper Juhl <jj@chaosbits.net> wrote:

> This patch fixes these compiler warnings:
> 
>   CC      drivers/staging/gma500/psb_gtt.o
> drivers/staging/gma500/psb_gtt.c: In function ¡psb_gtt_insert¢:
> drivers/staging/gma500/psb_gtt.c:81:33: warning: unused variable ¡dev_priv¢ [-Wunused-variable]
> drivers/staging/gma500/psb_gtt.c: In function ¡psb_gtt_pin¢:
> drivers/staging/gma500/psb_gtt.c:237:2: warning: ¡ret¢ may be used uninitialized in this function [-Wuninitialized]
> 
> It also fixes up the format string used in DRM_DEBUG() in
> drivers/staging/gma500/psb_gtt.c:psb_gtt_init() - the string required
> two arguments but only one was supplied.
> 
> While reading through the file I also deleted what trailing whitespace
> I encountered.

Unfortunately this file doesn't even exist in the working tree any more.
Please wait until Greg has taken the patch set I sent him to replace the
one that didn't apply, and the patch series after that (and quite
possibly the one after that assuming I can get Cedartrail to work next
week).

Alan

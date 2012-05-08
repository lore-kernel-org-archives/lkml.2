Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2EHUuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 16:50:50 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35233 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab2EHUus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 16:50:48 -0400
Date: Tue, 8 May 2012 21:53:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: linux-next: Tree for May 8 (gpu/drm/gma500)
Message-ID: <20120508215324.29b5cdc4@pyramind.ukuu.org.uk>
In-Reply-To: <4FA9496D.604@xenotime.net>
References: <20120508181531.072fdc5fefa60d852e784587@canb.auug.org.au>
	<4FA9496D.604@xenotime.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 May 2012 09:27:25 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 05/08/2012 01:15 AM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > There will be no linux-next tomorrow.
> > 
> > Changes since 20120507:
> 
> 
> 
> When CONFIG_ACPI is not enabled:
> 
> drivers/gpu/drm/gma500/opregion.c:269:3: error: implicit declaration of function 'register_acpi_notifier'
> drivers/gpu/drm/gma500/opregion.c:288:3: error: implicit declaration of function 'unregister_acpi_notifier'

Will take a look tomorrow.

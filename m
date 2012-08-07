Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab2HGJ6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:58:53 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34929 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab2HGJ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:58:52 -0400
Date: Tue, 7 Aug 2012 11:03:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sjur =?ISO-8859-1?B?QnLmbmRlbGFuZA==?= <sjurbren@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [RESEND PATCHv5 09/11] modem_shm: Character device for SHM
 channel access.
Message-ID: <20120807110323.65732799@pyramind.ukuu.org.uk>
In-Reply-To: <CAJK669YEbAq7xue9rAK9ikiUNm_ZVQZ4CaPhSr22xU56a_2B0g@mail.gmail.com>
References: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
	<1327999726-8774-10-git-send-email-sjur.brandeland@stericsson.com>
	<20120802112542.6ae3dd8f@pyramind.ukuu.org.uk>
	<CAJK669YEbAq7xue9rAK9ikiUNm_ZVQZ4CaPhSr22xU56a_2B0g@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am working on a re-spin of the entire patch-set for Modem-SHM using
> the RemoteProc framework from Ohad Ben Cohen and using Virtio as
> transport mechanism between modem and host. I hope to be able to
> use Virtio Console for the tty.The use-case tty/char device is for
> transfering boot images to the modem and fetch crash logs.

That would seem a sensible approach.

> For normal operation of the modem the CAIF protocol is used. I'm writing
> on a new CAIF-Virtio driver for this that works with the RemoteProc
> framework.

Ok.

Alan

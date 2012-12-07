Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030880Ab2LGVXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 16:23:52 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56995 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030866Ab2LGVXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 16:23:51 -0500
Date: Fri, 7 Dec 2012 21:28:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, tru@work-microwave.de, sr@denx.de,
        wg@grandegger.com
Subject: Re: [PATCH 0/6 v10] gpio: Add block GPIO
Message-ID: <20121207212845.1500ca25@pyramind.ukuu.org.uk>
In-Reply-To: <50C22868.4070405@antcom.de>
References: <1354830456-17590-1-git-send-email-stigge@antcom.de>
	<20121207103643.34ca6dc5@pyramind.ukuu.org.uk>
	<50C1DBD4.1040007@antcom.de>
	<50C1DE21.8050709@antcom.de>
	<20121207170215.0057f791@pyramind.ukuu.org.uk>
	<50C22868.4070405@antcom.de>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In the extreme case, define blocks with only a single GPIO in each of
> them, and the interface should still be faster than the sysfs one. Each
> block is a separate device node with separate permissions.

Ok, so it degenerates to the same case if needed. It's not ideal but I
have no suggestions how to improve it!

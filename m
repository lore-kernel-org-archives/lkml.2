Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0IGVD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 17:03:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35018 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751161Ab0IGVD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 17:03:26 -0400
Date: Tue, 7 Sep 2010 22:22:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: "avictor.za@gmail.com" <avictor.za@gmail.com>,
        David Brownell <david-b@pacbell.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        bn@niasdigital.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pio: add arch specific gpio_is_valid() function
Message-ID: <20100907222230.4a3594be@lxorguk.ukuu.org.uk>
In-Reply-To: <4C8692DE.1020202@bluewatersys.com>
References: <4C85BEFD.402@bluewatersys.com>
	<569801.35222.qm@web180310.mail.gq1.yahoo.com>
	<AANLkTinq98+ryOOKx1o1o21x9VnHz3nRCHh=5Wwixn4o@mail.gmail.com>
	<4C8692DE.1020202@bluewatersys.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Adding:
> 
> 	 device->output_pin = -EINVAL;

gpio numbers are unsigned in the rest of the API

It's unfortunate that 0 was used for a GPIO - I take it this is too late
to get fixed as we had to fix IRQ numbering and the like ?

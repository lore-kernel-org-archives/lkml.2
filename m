Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab2DLJrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 05:47:17 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35079 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762343Ab2DLJrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 05:47:16 -0400
Date: Thu, 12 Apr 2012 10:49:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Donald" <donald@asix.com.tw>
Cc: "'Greg KH'" <gregkh@linuxfoundation.org>,
        "'open list:USB SUBSYSTEM'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: Patch "USB: serial: mos7840: Supported MCS7810 device"
Message-ID: <20120412104936.65dd7683@pyramind.ukuu.org.uk>
In-Reply-To: <005301cd1871$87391a90$95ab4fb0$@com.tw>
References: <005301cd1871$87391a90$95ab4fb0$@com.tw>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* MCS7810 LED support */
> +#define MCS7810_HAS_LED

I would just enable this. Nobody is going to change it in their source
code.


> +#ifdef MCS7810_HAS_LED
> +	/* Turn on MCS7810 LED */
> +	if (serial->num_ports == 1 && mos7840_port->mos7810_led_flag == 0) {

Same comment as before about leds and flags to indicate features.

All these if cases should be a feature flag of some kind

Alan

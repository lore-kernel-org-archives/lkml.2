Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab2JXPy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:54:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52242 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab2JXPyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:54:25 -0400
Date: Wed, 24 Oct 2012 16:59:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Masanari Iida <standby24x7@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] [trivial] tty: Fix typo in tty drivers
Message-ID: <20121024165921.3dc0f9ee@pyramind.ukuu.org.uk>
In-Reply-To: <1351088981-24976-1-git-send-email-standby24x7@gmail.com>
References: <1351088981-24976-1-git-send-email-standby24x7@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +++ b/drivers/tty/serial/bfin_uart.c
> @@ -815,7 +815,7 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
>  		lcr = WLS(5);
>  		break;
>  	default:
> -		printk(KERN_ERR "%s: word lengh not supported\n",
> +		printk(KERN_ERR "%s: word length not supported\n",
>  			__func__);

Looks fine me although the bfin_uart one should just be picking a
suitable bit length and reporting back the one it uses not printing
errors 8)

Acked-by: Alan Cox <alan@linux.intel.com>

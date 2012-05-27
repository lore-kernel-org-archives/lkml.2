Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab2E0CdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 22:33:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65487 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab2E0CdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 22:33:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH RFC] serial/8250: Adjusting FIFO parameters for LPC32xx
Date: Sun, 27 May 2012 02:32:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org
References: <1338048678-23991-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1338048678-23991-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205270232.58253.arnd@arndb.de>
X-Provags-ID: V02:K0:77wraH6LQnKlQF1rgUeGSOgBDNU5gxinTqtH6I4WeUl
 2OGaH4KMeDrrVdGewfz6VUiIeK7k+AWD+e6tmA7H9ith9YcA4i
 J7ZVauwx1qgUSX5KUvwttAwLLOg+9vmpR/FuOgv0fwpIqjmYCu
 wMk0xRURo9SwUlfNNrB/LU3KjL734khY+pJfCPeXGohRBdJa98
 qYtqX/1L6jN9eYSGHU6rSrpgjhE1Xq+BcB21SFhASSz9uxqCOm
 w2sFU79+mGw9hPRPpPcmEeOjqZJqkxclHMRiSWFacbnM2TrFo8
 N/CgJ2otnd8ySbbbRShN59m/iYG8C5t+AaOeM8Y94O+2N2qSQh
 k6WaxdIZyrj6mlgvZmio=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2012, Roland Stigge wrote:
> Hi,
> 
> this is how the modified FIFO is handled in the repositories at
> git.lpclinux.com. Is there a better way for doing this (without ifdef)?  Looks
> like registering additional types (like PORT_16550A) isn't encouraged.  Maybe
> extending of_serial.c? The latter currently doesn't handle .fifosize and
> .tx_loadsz, though.
> 
> Any suggestions appreciated.

We occasionally add new types, and I think that would be ok here too, if it's
actually a new type. It definitely doesn't look like a 16550.

I wonder if it's in fact a PORT_16654, or if we can at least pretend it's one.
	
	Arnd

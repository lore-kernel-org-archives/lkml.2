Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab2JSJvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:51:48 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45777 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab2JSJvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:51:46 -0400
Date: Fri, 19 Oct 2012 10:56:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Florian Fainelli <ffainelli@freebox.fr>
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mbizon@freebox.fr
Subject: Re: [PATCH tty-next] x86: ce4100: allow second UART usage
Message-ID: <20121019105636.56e89a5a@pyramind.ukuu.org.uk>
In-Reply-To: <1350636307-23476-1-git-send-email-ffainelli@freebox.fr>
References: <1350636307-23476-1-git-send-email-ffainelli@freebox.fr>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012 10:45:07 +0200
Florian Fainelli <ffainelli@freebox.fr> wrote:

> From: Maxime Bizon <mbizon@freebox.fr>
> 
> The current CE4100 and 8250_pci code have both a limitation preventing the
> registration and usage of CE4100's second UART. This patch changes the
> platform code fixing up the UART port to work on a relative UART port
> base address, as well as the 8250_pci code to make it register 2 UART ports
> for CE4100 and pass the port index down to all consumers.
> 
> Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>

Acked-by: Alan Cox <alan@linux.intel.com>

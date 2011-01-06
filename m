Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1AFNp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 08:45:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34977 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752087Ab1AFNpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 08:45:23 -0500
Date: Thu, 6 Jan 2011 13:42:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [000/152] 2.6.36.3-stable review
Message-ID: <20110106134254.68fa27ac@lxorguk.ukuu.org.uk>
In-Reply-To: <20110106002500.GA3172@kroah.com>
References: <20110106002500.GA3172@kroah.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jan 2011 16:25:00 -0800
Greg KH <gregkh@suse.de> wrote:

> 
> This is the start of the stable review cycle for the 2.6.36.3 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.

Look sane on first glance but we don't seem to have a revert for the
serial mess up yet ?

> 7a56aa45982bb87bfca98a2832b5ae782c03364a is the first bad commit 
> commit 7a56aa45982bb87bfca98a2832b5ae782c03364a
> Author: Yegor Yefremov <yegor_sub1@visionsystems.de>
> Date:   Wed Jun 16 16:29:55 2010 +0200
> 
>     serial: add UART_CAP_EFR and UART_CAP_SLEEP flags to 16C950 UARTs 
> definition
>     
>     Adding UART_CAP_EFR and UART_CAP_SLEEP flags will enable sleep 
> mode
>     and automatic CTS flow control for 16C950 UARTs. It will also 
> avoid
>     capabilities detection warning like this:
>     
>     "ttyS0: detected caps 00000700 should be 00000100"
>     
>     Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


Has been bisected by several people to be causing failures and reported ?


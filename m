Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab0G0HcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 03:32:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45694 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752706Ab0G0HcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 03:32:24 -0400
Date: Tue, 27 Jul 2010 08:43:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20100727084353.5b14224a@lxorguk.ukuu.org.uk>
In-Reply-To: <20100727151843.7d253148.sfr@canb.auug.org.au>
References: <20100727151843.7d253148.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 15:18:43 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Greg,
> 
> After merging the tty tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/serial/mfd.c:37:30: error: linux/serial_mfd.h: No such file or directory
> drivers/serial/mfd.c: In function 'port_show_regs':
> drivers/serial/mfd.c:166: error: 'UART_FOR' undeclared (first use in this function)
> 
> ... and on ... and on ...
> 
> Caused by commit c3190cf68dfc58c33de0fd59b919cbb864acbba4 ("hsu: driver
> for Medfield High Speed UART device") and following.   Did it miss a file?
> 
> A little more care and testing, please.

Yes although I had a local copy so it built and tested beautifully 8(

Will send Greg and updated set of those patches versus todays -next

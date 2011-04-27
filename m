Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab1D0OO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:14:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43245 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756427Ab1D0OO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:14:58 -0400
Date: Wed, 27 Apr 2011 15:15:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: johnlinn@comcast.net
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        michal simek <michal.simek@petalogix.com>, joe@perches.com,
        grant likely <grant.likely@secretlab.ca>, greg@kroah.com
Subject: Re: [PATCH V3] tty/serial: add support for Xilinx PS UART
Message-ID: <20110427151520.32b0d2fb@lxorguk.ukuu.org.uk>
In-Reply-To: <126598808.1934339.1303910496698.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
References: <20110427103340.2554df83@lxorguk.ukuu.org.uk>
	<126598808.1934339.1303910496698.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I meant we were not detecting if the error was too much and finding the 
> nearest baud rate that had an acceptable amount of error. 

If you hand back the baud rate you ended up with the tty layer then it
will do the rest for you.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab1CRSGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 14:06:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53196 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752800Ab1CRSGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 14:06:47 -0400
Date: Fri, 18 Mar 2011 18:06:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: balbi@ti.com
Cc: Stefan Bigler <stefan.bigler@keymile.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: TTY loosing data with u_serial gadget
Message-ID: <20110318180657.11570887@lxorguk.ukuu.org.uk>
In-Reply-To: <20110318170801.GA2857@legolas.emea.dhcp.ti.com>
References: <4D8121F6.9060600@keymile.com>
	<20110317000408.GA18911@kroah.com>
	<4D8389EC.5030704@keymile.com>
	<20110318170801.GA2857@legolas.emea.dhcp.ti.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I had the same problem while I was working at Nokia developing the N900.
> I even sent a patch (twice) with Alan Cox on the loop but nothing has
> happened.

http://lkml.indiana.edu/hypermail/linux/kernel/0910.0/02347.html

is I assume the thread you are talking about - which ground to a halt
without actually figuring out what you were seeing and what was really
going on.

http://permalink.gmane.org/gmane.linux.usb.general/28976

would be the second generation one which was somewhat longer after I
ceased to be tty maintainer so I can't really say it never got upstream.

I still think its the right thing to do, so perhaps it's worth reposting
it, especially if it fixes this case too.

Alan

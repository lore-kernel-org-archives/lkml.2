Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1CVLD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:03:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60149 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751480Ab1CVLD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:03:56 -0400
Date: Tue, 22 Mar 2011 11:04:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: balbi@ti.com
Cc: Stefan Bigler <stefan.bigler@keymile.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: TTY loosing data with u_serial gadget
Message-ID: <20110322110412.3d374b48@lxorguk.ukuu.org.uk>
In-Reply-To: <20110322085344.GN1837@legolas.emea.dhcp.ti.com>
References: <4D8121F6.9060600@keymile.com>
	<20110317000408.GA18911@kroah.com>
	<4D8389EC.5030704@keymile.com>
	<20110318170801.GA2857@legolas.emea.dhcp.ti.com>
	<20110318180657.11570887@lxorguk.ukuu.org.uk>
	<20110321093255.GE1837@legolas.emea.dhcp.ti.com>
	<20110322085344.GN1837@legolas.emea.dhcp.ti.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Patch attached, please give it a good round of test as I don't have how
> to exercise all line disciplines. I ran 100 randconfigs over night and
> no warnings or erros on that area, at least not that I could see (so
> many warning while compiling the kernel :-( )

n_tty is I believe the only ldisc which assets throttling - the others
actually prefer to lose data on an overflow not get further blockages.


Greg - can we get this into -next once -rc1 is out and see who screams ?

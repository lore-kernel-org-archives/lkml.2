Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1EFMWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:22:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54593 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754034Ab1EFMWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:22:46 -0400
Date: Fri, 6 May 2011 13:23:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: michal.simek@petalogix.com
Cc: johnlinn@comcast.net, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        joe@perches.com, grant likely <grant.likely@secretlab.ca>,
        John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH V4] tty/serial: add support for Xilinx PS UART
Message-ID: <20110506132344.1d166260@lxorguk.ukuu.org.uk>
In-Reply-To: <4DC3E580.9090500@petalogix.com>
References: <1013673718.2094564.1304113268455.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
	<4DC3E580.9090500@petalogix.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't agree with this change. NO_IRQ for microblaze, arm and other is -1. BTW: 
> For ppc is 0. Using NO_IRQ seems to me reasonable.

0 means "no interrupt".

The old mis-use of -1 is an old mostly ARM specific ugly that ahould be
going away not getting repeated further. If Microblaze is using this hack
then it needs to stop.

NO_IRQ was *purposefully* removed from general consumption a long time
ago for a good reason (historically it was an IDE driver internal define
certain people borrowed)

Alan

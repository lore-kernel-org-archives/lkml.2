Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab1G2SLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:11:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52623 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750756Ab1G2SLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:11:43 -0400
Date: Fri, 29 Jul 2011 19:14:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Breno Leitao <leitao@linux.vnet.ibm.com>
Subject: Re: Very strange data loss with jsm driver
Message-ID: <20110729191442.35d09111@lxorguk.ukuu.org.uk>
In-Reply-To: <20110729180650.GL8562@caffeine.csclub.uwaterloo.ca>
References: <20110729160416.GK8562@caffeine.csclub.uwaterloo.ca>
	<20110729172736.4b199d31@lxorguk.ukuu.org.uk>
	<20110729165342.GB8566@caffeine.csclub.uwaterloo.ca>
	<20110729180650.GL8562@caffeine.csclub.uwaterloo.ca>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I noticed fifosize in the uart_port info is set to 16, even though the
> fifo size is actually 64 bytes as all actual driver bits know.  What is
> fifosize actually used for?

Only within the driver. The generic code merely knows how it as a
configuration property but doesn't use it.

Alan

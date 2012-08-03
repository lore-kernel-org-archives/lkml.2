Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2HCNZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:25:03 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58987 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab2HCNY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:24:58 -0400
Date: Fri, 3 Aug 2012 14:29:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: dmarkh@cfl.rr.com
Cc: Chris Friesen <chris.friesen@genband.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_LICENSE("GPL")??
Message-ID: <20120803142923.311c70b6@pyramind.ukuu.org.uk>
In-Reply-To: <501BBE45.8060309@cfl.rr.com>
References: <50199E91.5040308@cfl.rr.com>
	<20120801224342.5b90747f@pyramind.ukuu.org.uk>
	<501A704E.2000301@cfl.rr.com>
	<501B5D51.5030307@genband.com>
	<501BBE45.8060309@cfl.rr.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> assumption that that actually meant they were NOT using GPL symbols.

All symbols in the Linux kernel are to GPL code and all linking dynamic
or otherwise is subject to the GPL licence. That is you need to be able
to show anything non-free linked with it such as a kernel module is not a
derivative work.

Alan

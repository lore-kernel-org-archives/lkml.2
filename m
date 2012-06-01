Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab2FAH4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 03:56:34 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40154 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab2FAH4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 03:56:33 -0400
Date: Fri, 1 Jun 2012 09:00:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Harald Welte <laforge@gnumonks.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] List LGPL (v2 / v2.1) as GPL compatible in
 license_is_gpl_compatible()
Message-ID: <20120601090003.2f7090c1@pyramind.ukuu.org.uk>
In-Reply-To: <20120531222407.GB5256@prithivi.gnumonks.org>
References: <20120531222407.GB5256@prithivi.gnumonks.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2012 00:24:07 +0200
Harald Welte <laforge@gnumonks.org> wrote:

> It may be a highly unusual choice to license Linux kernel drivers under
> LGPL, but at least as long as LGPLv2 or LGPLv2.1 is used, this is fully
> GPL compatible and shouldn't taint the kernel.

We need to be careful here that people don't think they can use an LGPL
module with a GPL kernel and then use that to load proprietary bits, but
beyond that obvious interpretation point this seems reasonable.


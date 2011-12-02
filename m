Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1LBL3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 06:29:43 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39286 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754100Ab1LBL3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 06:29:42 -0500
Date: Fri, 2 Dec 2011 11:30:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Scott Wood <scottwood@freescale.com>, <gregkh@suse.de>,
        <alan@linux.intel.com>, <linux-serial@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] 8250: add workaround for MPC8[356]xx UART break IRQ
 storm
Message-ID: <20111202113059.15d73840@lxorguk.ukuu.org.uk>
In-Reply-To: <176AE2A1-6AA2-4F14-942F-8ED77AB1DBEC@kernel.crashing.org>
References: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>
	<1322783258-20443-4-git-send-email-paul.gortmaker@windriver.com>
	<4ED812E4.60905@freescale.com>
	<4ED81632.3030809@windriver.com>
	<176AE2A1-6AA2-4F14-942F-8ED77AB1DBEC@kernel.crashing.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > OK, I'll simply change the above to CONFIG_PPC then.
> 
> It does, the bug is in the uart IP which I don't think we ever plan on fixing, so 32 or 64-bit parts will have it for ever and ever ;)

It should be runtime selected, there should be no ifdefs here.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab2A3K1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 05:27:20 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41761 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab2A3K1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 05:27:18 -0500
Date: Mon, 30 Jan 2012 10:28:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrea Shepard <andrea@persephoneslair.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, khc@pm.waw.pl,
        davem@davemloft.net, mmarek@suse.cz, jkosina@suse.cz, joe@perches.com,
        justinmattock@gmail.com, gregkh@suse.de, alan@linux.intel.com,
        jdmason@kudzu.us
Subject: Re: [00/22] Cyclades PC300 driver: summary of patch series
Message-ID: <20120130102815.3e01acc4@pyramind.ukuu.org.uk>
In-Reply-To: <20120130024243.GA10262@cronus.persephoneslair.org>
References: <20120130024243.GA10262@cronus.persephoneslair.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jan 2012 18:42:43 -0800
Andrea Shepard <andrea@persephoneslair.org> wrote:

> The Cyclades PC-300 is a line of PCI synchronous serial cards, which was
> produced in single and dual port models with either T1/E1 or V.35 ports.
> It used a Hitachi HD64572 (SCA-II) synchronous serial chip, and in the
> T1/E1 models an Infineon FALC-LH line interface/framing chip.  Copies
> of the hardware documentation may be found at [1].

The cleanup is better than it was but has lots left to sort. I think this
may actually be a good example of where the staging tree is useful as
it'll avoid this turning into a hundred cycles of adding another patch to
the enormous pile and can instead be done in step by step.

Alan

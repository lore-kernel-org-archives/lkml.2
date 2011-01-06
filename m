Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1AFNsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 08:48:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34981 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751725Ab1AFNsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 08:48:19 -0500
Date: Thu, 6 Jan 2011 13:47:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: sclark46@earthlink.net
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel 2.6.37 erroneously limiting to UDMA/33
Message-ID: <20110106134704.20b91684@lxorguk.ukuu.org.uk>
In-Reply-To: <4D24B98D.6080307@earthlink.net>
References: <4D24B98D.6080307@earthlink.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Jan 2011 13:33:49 -0500
Stephen Clark <sclark46@earthlink.net> wrote:

> Hello,
> 
> Why is the kernel limiting me to udma/33 when the device says it can do
> ata2.01: CFA: TRANSCEND, 20070831, max UDMA/66
> 
> There is no cable the compact flash is a socket on the motherboard!

The kernel follows the ATA detection rules. If you have an adapter wedged
into the PATA socket one motherboard then it could well be either the
adapter isn't UDMA/66 capable or is not properly supporting cable detect.

You can force it with boot options.

If the CF socket is directly wired to and part of the motherboard (ie
it's part of the board configuration), then can you send me a dmidecode,
lspci and lspci --vvxxx as we can patch up configurations that are fixed,
but not user added adapters.

Alan

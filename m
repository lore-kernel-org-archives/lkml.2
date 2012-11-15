Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767739Ab2KOMwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 07:52:33 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54188 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767700Ab2KOMwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:52:32 -0500
Date: Thu, 15 Nov 2012 12:57:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Forconi <forconi@wavecomm.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: KMS Framebuffer on Intel N2600 (GMA3600)
Message-ID: <20121115125749.3604ebdf@pyramind.ukuu.org.uk>
In-Reply-To: <1851235145.1360402.1352970575153.JavaMail.root@zmail.sgconsulting.it>
References: <20121114171755.27b8423b@pyramind.ukuu.org.uk>
	<1851235145.1360402.1352970575153.JavaMail.root@zmail.sgconsulting.it>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012 09:09:35 +0000 (UTC)
Forconi <forconi@wavecomm.it> wrote:

> Hi Alan,
> thanks again for your answer.
> 
> Reading the manual of the board I found this specification:
> LVDS: 24-bit dual channel via CH7511 thru eDP
> 
> The Chrontel CH7511 is a DisplayPort (DP/eDP) to LVDS converter.
> 
> So, what I understand is that the LVDS interface that comes out
> from the connector on the board is connected to the CH7511 that
> is connected to the DP/eDP port on the CPU.
> 
> Until now I was starting the kernel with video=LVDS-1.....,
> maybe I have to use another video device like DVI to use the eDP port?

Could help explain why there is no backlight. Initial eDP support got
added to the driver very recently so it might work but it should still
have decided itself you have eDP given a current kernel.

Alan

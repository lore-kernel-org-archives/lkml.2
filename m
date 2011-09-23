Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab1IWKGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 06:06:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55497 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752053Ab1IWKGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 06:06:50 -0400
Date: Fri, 23 Sep 2011 11:05:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nikola Diklic-Perin <diklic.perin.nikola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] tty/n_gsm: fix bug in tiocmset
Message-ID: <20110923110520.1119aeb9@lxorguk.ukuu.org.uk>
In-Reply-To: <CAJnFFh3XRFEC49yFvjstreqqkeraA9GA1_AL-s9rj87HksdgBg@mail.gmail.com>
References: <CAJnFFh3XRFEC49yFvjstreqqkeraA9GA1_AL-s9rj87HksdgBg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Sep 2011 10:59:43 +0200
Nikola Diklic-Perin <diklic.perin.nikola@gmail.com> wrote:

> From: Nikola Diklic-Perin <diklic.perin.nikola@gmail.com>
> 
> Clear bitmask was not inverted before masking modem_tx.
> 
> Calling ioctl(fd, TIOCMBIC, TIOCM_RTS) results in:
> 
> [  197.430000] pre_modem_tx:	0x00000006
> [  197.430000] clear:			0x00000004
> [  197.430000] set:			0x00000000
> [  197.440000] post_modem_tx:	0x00000004
> 
> which is wrong.
> 
> Signed-off-by: Nikola Diklic-Perin <diklic.perin.nikola@gmail.com>

Acked-by: Alan Cox <alan@linx.intel.com>

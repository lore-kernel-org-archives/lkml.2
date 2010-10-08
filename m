Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab0JHKW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:22:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39970 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753745Ab0JHKW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:22:56 -0400
Date: Fri, 8 Oct 2010 11:48:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Suraj Sumangala <suraj@Atheros.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Subject: Re: Peculiar stuff in hci_ath3k/badness in hci_uart
Message-ID: <20101008114855.7dfd255d@lxorguk.ukuu.org.uk>
In-Reply-To: <4CAEE1DB.1070202@Atheros.com>
References: <20101007214134.6bcd2e8f@lxorguk.ukuu.org.uk>
	<4CAEE1DB.1070202@Atheros.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010 14:48:19 +0530
Suraj Sumangala <suraj@Atheros.com> wrote:

> Hi Alan,
> 
> On 10/8/2010 2:11 AM, Alan Cox wrote:
> > Noticed this while looking at Savoy's stuff
> >
> >
> > ath_wakeup_ar3k:
> >
> >         int status = tty->driver->ops->tiocmget(tty, NULL);
> >
> I agree, it will be a problem if the underlying driver try to access the 
> "struct file". Is there any other way I can get the MCR status here 
> without providing user space pointer?

Currently no - that should get fixed in the tty layer and I will look
into it end of next week as a priority.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab1HJJbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:31:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54042 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752633Ab1HJJbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:31:10 -0400
Date: Wed, 10 Aug 2011 10:34:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: Regarding USB-RS485 Cable Manufacturer: FTDI SerialNumber:
 FTU6Z938
Message-ID: <20110810103417.71b28550@lxorguk.ukuu.org.uk>
In-Reply-To: <20110810051603.M89044@admin-gateway.ncra.tifr.res.in>
References: <20110810051603.M89044@admin-gateway.ncra.tifr.res.in>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011 10:55:39 +0530
"Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in> wrote:

> 
> Hello Greg,
>            I have purchased a USB-RS485 Cable Manufacturer: FTDI SerialNumber: FTU6Z938.
> And I have written a user space program to communicate with my Rs-485 device at the
> other end.The device at the other end expect 1 address byte with mark parity and rest of
> the bytes with space parity

Linux will be doing RS232/422 by default. If you are doing EIA-485 then
you also need to manage the transmitter and how that is handled is going
to depend upon the cable you have. It may need driver changes, it may
simply need you to manage the carrier assert and sometimes carrier
presence in order to implement the transmitter.

Really you'll need to look at the suppliers data sheets and see.

Alan


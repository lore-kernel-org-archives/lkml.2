Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1HWKQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 06:16:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53593 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752108Ab1HWKQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 06:16:33 -0400
Date: Tue, 23 Aug 2011 11:14:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <greg@kroah.com>, linux-arm-kernel@lists.infradead.org,
        nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Bernhard Roth <br@pwrnet.de>
Subject: Re: [PATCH] atmel_serial: RS485: receiving enabled when sending
 data
Message-ID: <20110823111438.5d6b286d@lxorguk.ukuu.org.uk>
In-Reply-To: <4E537BB3.60001@evidence.eu.com>
References: <4E492CFF.7040905@pwrnet.de>
	<20110822211832.GA8023@kroah.com>
	<4E536536.3030004@evidence.eu.com>
	<20110823093035.GB19622@n2100.arm.linux.org.uk>
	<4E537BB3.60001@evidence.eu.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> atmel_serial: RS485: receiving enabled when sending data
> 
> By default the atmel_serial driver in RS485 mode disables receiving data until
> all data in the send buffer has been sent. This flag allows to receive data
> even whilst sending data.
> 
> Signed-off-by: Bernhard Roth <br@pwrnet.de> 
> Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>

Acked-by: Alan Cox <alan@linux.intel.com>

(although when we have people having a serious meta discussion about four
 spaces, or a tab or neither rather than functionality I despair)

This is sensible functionality and relevant to various interfaces so
makes sense.

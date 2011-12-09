Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1LIS5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:57:45 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36264 "EHLO
	pyramind.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752518Ab1LIS5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:57:44 -0500
Date: Fri, 9 Dec 2011 18:58:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Claudio Scordino <claudio@evidence.eu.com>
Subject: Re: [PATCH RESEND 1/8] serial: 8250: replace hardcoded 0xbf with
 #define
Message-ID: <20111209185818.589039f9@pyramind.ukuu.org.uk>
In-Reply-To: <1323450440-414-2-git-send-email-w.sang@pengutronix.de>
References: <1323450440-414-1-git-send-email-w.sang@pengutronix.de>
	<1323450440-414-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Dec 2011 18:07:13 +0100
Wolfram Sang <w.sang@pengutronix.de> wrote:

> Makes it easier to find all occurences requesting CONF_MODE_B.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

Acked-by: Alan Cox <alan@linux.intel.com>

That should go in anyway

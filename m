Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab0JXIi2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 04:38:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46038 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932229Ab0JXIi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 04:38:26 -0400
Date: Sun, 24 Oct 2010 09:37:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alon Ziv <alon@nolaviz.org>
Cc: Greg KH <gregkh@suse.de>, Alon Ziv <alon+git@nolaviz.org>,
        linux-usb@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Stefani Seibold <stefani@seibold.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Export usb_serial_generic_write_room for use in
 other modules
Message-ID: <20101024093701.67850d1b@lxorguk.ukuu.org.uk>
In-Reply-To: <4CC3159E.3030500@nolaviz.org>
References: <1287850818-12050-1-git-send-email-alon-git@nolaviz.org>
	<1287850818-12050-2-git-send-email-alon-git@nolaviz.org>
	<20101023163747.GA20381@suse.de>
	<4CC3159E.3030500@nolaviz.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The generic code does not invoke the write_room callback before invoking
> break_ctl, so there is no way to use this function in usb_serial.

Why would it ?

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2CCXzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 18:55:11 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41591 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab2CCXzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 18:55:10 -0500
Date: Sat, 3 Mar 2012 23:57:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [RFC] firmware loader: retry _nowait requests when userhelper
 is not yet available
Message-ID: <20120303235704.2df2b040@pyramind.ukuu.org.uk>
In-Reply-To: <201203032122.36745.chunkeey@googlemail.com>
References: <201203032122.36745.chunkeey@googlemail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2012 21:22:36 +0100
Christian Lamparter <chunkeey@googlemail.com> wrote:

> During resume, the userhelper might not be available. However for
> drivers which use the request_firmware_nowait interface, this will
> only lead to a pointless WARNING and a device which no longer works
> after the resume [since it couldn't get the firmware, because the
> userhelper was not available to take the request].

Can you not load the firmware on the suspend path ?

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab2BZNiM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 08:38:12 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53733 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2BZNiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 08:38:10 -0500
Date: Sun, 26 Feb 2012 13:40:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Prasanna Kumar T S M <prasannatsmkumar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Module Load order
Message-ID: <20120226134005.687b1622@pyramind.ukuu.org.uk>
In-Reply-To: <4F49E87B.1050708@gmail.com>
References: <4F49E87B.1050708@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Feb 2012 13:38:27 +0530
Prasanna Kumar T S M <prasannatsmkumar@gmail.com> wrote:

> Is there any specific module load order in Linux? If there is a GPL
> driver and binary driver for a particular device which will be loaded?
> Is there any logic to load GPL driver built inside the kernel? Or is the
> module search and load is handled by some other component (like udev)
> and not the kernel? Sorry for my ignorance if I have asked this to a
> wrong list.

There should never be two drivers for one piece of hardware. There may be
two for the same PCI ID however which grab different device versions. In
that case both drivers get loaded and the probe routine figures out which
to bind.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab1KHVP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 16:15:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41303 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753536Ab1KHVP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 16:15:56 -0500
Date: Tue, 8 Nov 2011 21:16:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Staging clear up
Message-ID: <20111108211656.29defdda@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moorestown/Oaktrail has appeared only in the PC like form so the
following bits of staging can be binned

drivers/staging/spectra

(not needed)

drivers/staging/intel_sst

This also appears on Medfield but there is an ASoC driver for the
Medfield version and we no longer need to keep this. There were naughty
bits of code peeking into staging for files but that should now be sorted
(and if not they need to break and be forced to fix them)

I can send patches but they are enormous and rather boring...

I will be sending patches for other bits like the battery manager which
in actual product is always ACPI handled.

Alan

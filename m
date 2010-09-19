Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0ISAg7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 20:36:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40792 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753661Ab0ISAg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 20:36:58 -0400
Date: Sun, 19 Sep 2010 01:59:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Joshua Hintze" <joshh@imsar.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
Subject: Re: PATA IDE is slower in newer versions of kernel
Message-ID: <20100919015903.49606426@lxorguk.ukuu.org.uk>
In-Reply-To: <010901cb5754$ae6735a0$0b35a0e0$@com>
References: <00d401cb55f7$33a78210$9af68630$@com>
	<20100917154732.330c4b1b@varda>
	<010901cb5754$ae6735a0$0b35a0e0$@com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm dedicated to continue working on the problem, I just need to advice from the linux community. I've tried different I/O schedulers such as noop and anticipatory and I'm studying the ide-dma code but still lost to where this is happening.

drivers/ide is pretty much obsolete - so what you are seeing is doubly
odd. Most stuff now is using the newer drivers/ata code which can support
SATA, NCQ etc unlike the old codebase.

One thing to check would be whether using the drivers/ata code shows the
same problem.

Alan

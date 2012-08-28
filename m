Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab2H1KvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 06:51:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35359 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2H1KvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 06:51:08 -0400
Date: Tue, 28 Aug 2012 11:55:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: mathieu.poirier@linaro.org, linux-kernel@vger.kernel.org, arve@android.com,
        kernel-team@android.com, dmitry.torokhov@gmail.com,
        john.stultz@linaro.org
Subject: Re: [PATCH] drivers/tty: Folding Android's keyreset driver in sysRQ
Message-ID: <20120828115550.1b9c0293@pyramind.ukuu.org.uk>
In-Reply-To: <503C03FA.5080803@xenotime.net>
References: <1346103825-14430-1-git-send-email-mathieu.poirier@linaro.org>
	<503C03FA.5080803@xenotime.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please document what button/key combinations those are.

It's taken from the platform data. Most phone devices don't have a real
keyboard let alone an sysrq key so it's device specific button combos in
general that trigger things like power off.

> 
> > The first time the key-combo is detected a work function that syncs
> > the filesystems is scheduled and the kernel rebooted. If all the keys
> > are released and then pressed again, it calls panic. Reboot on panic
> > should be set for this to work.  A platform device that specify a
> > reset key-combo should be added to the board file to trigger the
> > feature.

And it is documented ... ^^^^^^^^^^^^^^^^^^^^^^^^^^


Alan

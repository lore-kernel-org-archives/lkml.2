Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab2KYXve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 18:51:34 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39755 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab2KYXvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 18:51:33 -0500
Date: Sun, 25 Nov 2012 23:56:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Roland Eggner <edvx1@systemanalysen.net>
Cc: Dimitrios Apostolou <jimis@gmx.net>, linux-kernel@vger.kernel.org
Subject: Re: backing up ext4 fs, system unresponsive, thrashing like crazy
 even though swap is unused
Message-ID: <20121125235651.2f73a539@pyramind.ukuu.org.uk>
In-Reply-To: <20121125225954.GA14653@mobil.systemanalysen.net>
References: <1353851735.22969.18.camel@soupermouf>
	<1353871800.22969.28.camel@soupermouf>
	<20121125225954.GA14653@mobil.systemanalysen.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does anybody know a x86 distribution or live-CD using a 2.6.27.* kernel?

Probably not a good idea, there are known exploitable holes in 2.6.27 era
kernels and nobody maintains anything that old.

I guess RHEL/Centos might work for you.

I've not had any problems with leaks in 3.6 but there have been a few
reports and its clear that some obscure configurations trigger something
bad.

Gnome 3 on the other hand leaks like a sieve.

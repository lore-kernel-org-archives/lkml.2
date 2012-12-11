Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2LKKVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 05:21:19 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60358 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab2LKKVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 05:21:18 -0500
Date: Tue, 11 Dec 2012 10:26:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Woody Wu <narkewoody@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Serial8250 doesn't populate in /proc/iomem?
Message-ID: <20121211102644.0be2eb94@pyramind.ukuu.org.uk>
In-Reply-To: <slrnkcd1uq.28d.narkewoody@zuhnb712.local.com>
References: <slrnkcb00b.77o.narkewoody@zuhnb712.local.com>
	<slrnkcd1uq.28d.narkewoody@zuhnb712.local.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You see, there is no serial8250 informations.
> >
> > Can anyone here please tell me how this can happen?  Does it mean the
> > serial8250 driver don't populate or register in the /proc/iomem?
> 
> Could someone help me? Thanks!

I think you are in the wrong place - the kernel newbies list may be a
better place to ask this level of question.


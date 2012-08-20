Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab2HTXMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 19:12:00 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54380 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2HTXL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 19:11:56 -0400
Date: Tue, 21 Aug 2012 00:16:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: "mr.shroom" <mr.shroom@gmail.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: Bug report
Message-ID: <20120821001635.5e9e2afc@pyramind.ukuu.org.uk>
In-Reply-To: <5032BD97.7070701@xenotime.net>
References: <CAL=PgHMH=5A5rLaO=RvYYA8MmcKEt1zay7f2=SS83RYayVVh+w@mail.gmail.com>
	<5032BD97.7070701@xenotime.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2012 15:43:35 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> (cc-ing linux-ide mailing list)

Classic "no IRQ being delivered" - looks like a platform IRQ routing
problem

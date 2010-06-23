Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab0FWJL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 05:11:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42244 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751117Ab0FWJLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 05:11:55 -0400
Date: Wed, 23 Jun 2010 10:16:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <kees.cook@canonical.com>
Cc: Christian Stroetmann <stroetmann@ontolinux.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux File System ML <linux-fsdevel@vger.kernel.org>,
       Linux Security Module ML 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] security: Yama LSM
Message-ID: <20100623101648.3d2cf65d@lxorguk.ukuu.org.uk>
In-Reply-To: <20100623062242.GG5876@outflux.net>
References: <20100621213424.GG24749@outflux.net>
	<201006220028.o5M0Sbx7062650@www262.sakura.ne.jp>
	<20100622011452.GN24749@outflux.net>
	<4C20ABC0.5050908@nokia.com>
	<20100622160613.GC5876@outflux.net>
	<4C21A39C.6040406@ontolinux.com>
	<20100623062242.GG5876@outflux.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have done the latter.
> 
> I don't need to integrate this into grsecurity because grsecurity already
> has these protections.  It is Openwall and grsecurity that I'm using as the
> starting point for this attempt at upstreaming the protections.

In effect its turning bits of grsecurity into an LSM which is a good
thing.


Alan

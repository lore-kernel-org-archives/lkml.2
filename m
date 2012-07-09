Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab2GIPqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 11:46:20 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55580 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab2GIPqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 11:46:19 -0400
Date: Mon, 9 Jul 2012 16:49:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120709164956.4baaf7a4@pyramind.ukuu.org.uk>
In-Reply-To: <201207091532.12256.arnd@arndb.de>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	<20120709113558.GE8052@arm.com>
	<20120709145126.313d1574@pyramind.ukuu.org.uk>
	<201207091532.12256.arnd@arndb.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the main strategy should be to spot duplicate code early
> and make sure we deal with it individually. Examples for this are
> probably the implementations for kvm and perf, which largely deal
> with the same hardware on both architectures. Those definitely must
> not get duplicated into mostly-identical files. In many cases, we're
> moving those things into drivers/*, in other cases we might want to
> use Makefile logic to include a sub-directory from one arch into another,
> as we do for arch/um.

If you want to put a subdir of one arch into another wouldn't it be
rather cleaner to use arm/arm/aarch64/ as your architecture base ?

Alan

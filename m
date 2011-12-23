Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1LWHgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 02:36:51 -0500
Received: from mfb02-md.ns.itscom.net ([175.177.155.110]:51099 "EHLO
	mfb02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1LWHgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 02:36:49 -0500
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Dec 2011 02:36:49 EST
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: Intercepting system calls
To: Gaurav Saxena <grvsaxena419@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
Date: Fri, 23 Dec 2011 16:25:49 +0900
Message-ID: <1162.1324625149@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Gaurav,

Gaurav Saxena:
> I am writing an application for which I need to intercept some
> filesystem system calls eg. unlink. I need unlink to call my code
	:::

For kernel space, CONFIG_KPROBES may help you.
See Documentation/kprobes.txt in detail.

For user space, $LD_PRELOAD may help you.
You will need to develop your shared object library which contains
your_unlink() and replaces the original unlink().
See ld.so(8) manual page.


J. R. Okajima

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab1FGGZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 02:25:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38653 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1FGGZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 02:25:22 -0400
References: <BANLkTinrbh7Xi27an3uY7pDWrNKhJRYmEA@mail.gmail.com> <BANLkTik-xtEnf8Bxz3PmP6H+YYSDXe1adw@mail.gmail.com> <BANLkTim1ms9ND6evpDVPFRrJBNffMr4KNg@mail.gmail.com> <alpine.DEB.2.02.1106061308590.25491@asgard.lang.hm>
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.DEB.2.02.1106061308590.25491@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Linux 3.0-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 07 Jun 2011 15:22:42 +0900
To: david@lang.hm
CC: Alessandro Suardi <alessandro.suardi@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <81e5df54-4987-40ba-9333-79665efda719@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



david@lang.hm wrote:
>
>hmm, at this point would it make sense to have kernel.org generate the 
>tarball when it sees a new tag appear?

It's actually more of a "silly Linus scripts and workflow" issue. I have some trivial scripts that generate the tarballs and patches, and I'm just so used to running them at my own machine and then uploading them to the kernel.org machines.

I should just get used to doing the work directly on kernel.org, but normally it's faster and more convenient to just do it on my own machine. And I think this is the first time I've had an internet connection that was good enough to work with, but too flaky to actually upload things with.

I'll be home in another too many hours, will fix things up then..

I suspect not a lot of people actually use the tarballs these days. It's just much more convenient to get the tree with git.

        Linus


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690Ab1FGSNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:13:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55637 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675Ab1FGSNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:13:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NElqZn/ZHR4zJE5IbCGzC2NsIDaaHurus7HW2lleSceB7hHox0o9Tc2HhJuCcjZO/j
         KheKe3L5Q1caIuLbglkjii+I2JXSLdeie1kHuTagHg5AqAhn5HFzmjiRxODe0sYTVrAT
         eXYi/cEnE1EBIjusxtaLLPJmYOlHeQB72nOUE=
MIME-Version: 1.0
In-Reply-To: <4DEDCCFF.10801@turknetserver.com>
References: <BANLkTinrbh7Xi27an3uY7pDWrNKhJRYmEA@mail.gmail.com>
	<BANLkTik-xtEnf8Bxz3PmP6H+YYSDXe1adw@mail.gmail.com>
	<BANLkTim1ms9ND6evpDVPFRrJBNffMr4KNg@mail.gmail.com>
	<alpine.DEB.2.02.1106061308590.25491@asgard.lang.hm>
	<81e5df54-4987-40ba-9333-79665efda719@email.android.com>
	<4DEDCCFF.10801@turknetserver.com>
Date: Tue, 7 Jun 2011 11:13:06 -0700
Message-ID: <BANLkTinpYYGvgnfbfpa9Kt4nUjhZ4Y+Y3A@mail.gmail.com>
Subject: Re: Linux 3.0-rc2
From: Tony Luck <tony.luck@gmail.com>
To: Tarkan Erimer <tarkan@turknetserver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Alessandro Suardi <alessandro.suardi@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 12:02 AM, Tarkan Erimer <tarkan@turknetserver.com> wrote:
> I always use tarballs instead of git. Because; I have several Linux boxes
> and just one time I download the kernel tarball then spreading it with scp
> to other Linux boxes easily. Otherwise, I have to prepare a tarball by
> myself to distribute it which is a time waste and unpractical. Also, getting
> the whole 700-800 MB of kernel tree with git is not very Internet bandwidth
> (Consider that in some ISPs and countries, Internet usage is limited by
> monthly quotas.) friendly.

If you maintain a git tree, then at each release you will only need to pull a
small amount (the git delta from the last time you pulled).  It is then quite
simple to make your own tarball to copy around your machines with:

$ git archive --format=tar --prefix=linux/ v3.0-rc2 | gzip > v3.0-rc2.tgz

So you have a one time large bandwidth investment to do the initial
git clone, and then much less traffic for each update.

-Tony

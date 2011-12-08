Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1LHRF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 12:05:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60828 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab1LHRF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 12:05:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "John Stoffel" <john@stoffel.org>
Subject: Re: chroot(2) and bind mounts as non-root
Date: Thu, 8 Dec 2011 17:04:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Colin Walters <walters@verbum.org>, LKML <linux-kernel@vger.kernel.org>,
        morgan@kernel.org, serue@us.ibm.com, dhowells@redhat.com,
        kzak@redhat.com
References: <1323280461.10724.13.camel@lenny> <20191.49202.793643.397028@quad.stoffel.home>
In-Reply-To: <20191.49202.793643.397028@quad.stoffel.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112081704.22453.arnd@arndb.de>
X-Provags-ID: V02:K0:Pt+Xv8U9IdMLon5Ddv/xHQQHR5LPSctNhUNmnNfLCPC
 t4OVH9sav953iP6BOyAEsCgJFp3c2VntrP5lpOIVBhrxiSfPt2
 XP0LJlS6DxvHAOFyuFWWxyPvpxrKhOlw12BgVpKrO0e126enzo
 UoSgMXGviC+NEF89WMWnyZTb/+6IntTN6O50zy543wgg20iwIV
 RoAU+76qRZmTQTgZtzoFUw/nP1vOLMvWApSXV91hDfcmJ9Qs1i
 fAsejtx5yzdfDhHa18+IF8MdaPDR3Jelpqt39Bns9yf9qzNBGO
 gBsHOaeMCc5ddCDdBLgSk/xhPBAkA0SKsgiXNEbzpjkDM9dMFy
 rskdMBV28av6zYDti0WA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 December 2011, John Stoffel wrote:
> >>>>> "Colin" == Colin Walters <walters@verbum.org> writes:
> 
> Colin> I've recently been doing some work in software compilation, and it'd be
> Colin> really handy if I could call chroot(2) as a non-root user.  The reason
> Colin> to chroot is to help avoid "host contamination" - I can set up a build
> Colin> root and then chroot in.  The reason to do it as non-root is, well,
> Colin> requiring root to build software sucks for multiple obvious reasons.
> 
> What's wrong with using 'fakeroot' or tools like that instead?  Why
> does the Kernel need to be involved like this?  I'm not against your
> proposal so much, as trying to understand how compiling a bunch of
> source requires this change.

I think the better question to ask is what is missing from 'schroot', which
is commonly used for exactly this purpose. Is it just about avoing the
suid bit for /usr/bin/schroot or something else?

	Arnd

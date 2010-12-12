Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0LLTiL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 14:38:11 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:36723 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753861Ab0LLTiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 14:38:09 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+x78tIlROxw+giBwYNHVA4mU4EfVAXGXlC6g4Rcn
	XFEVWZljsgo+y1
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>
Subject: Re: [PATCH v2] avr32: Fix build failure conflicting types for 'sys_execve'
Date: Sun, 12 Dec 2010 20:37:58 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.4.5; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
References: <20101209182132.GB24175@kroah.com> <1291929328-30551-1-git-send-email-peterhuewe@gmx.de> <1291976741.18008.37.camel@hcegtvedt>
In-Reply-To: <1291976741.18008.37.camel@hcegtvedt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012122037.59016.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 10 Dezember 2010, 11:25:41 schrieb Hans-Christian Egtvedt:
> Nack, I've piped up a patch in
> http://git.kernel.org/?p=linux/kernel/git/egtvedt/avr32-2.6.git;a=shortlog;
> h=refs/heads/next that does this and more. The syscalls.h header file needs
> a bit more cleanup.
> 
> I'll also notify stable to get it backported. Do you have an idea how
> far back it should go?

Hi,

Linus' tree fails since August 19th due to this issue, so it falls into the 
2.6.36 merge window only.
http://kisskb.ellerman.id.au/kisskb/buildresult/3059836/
(but it still failed for quite a while longer due to other issues ;)


Thanks,
Peter
(a reported by on the patch would have been nice ;)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab0LTRJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:09:57 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41732 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932875Ab0LTRJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:09:56 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18auGksIMEaVICf4c4qsihpr6Q5Ba/4VmVjsIGrYL
	JNkYxOL5AX6hZc
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: sedat.dilek@gmail.com
Subject: Re: [PATCH] platform/x86: Fix recursive Kconfig dependency
Date: Mon, 20 Dec 2010 18:09:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.2; KDE/4.4.5; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Linville <linville@tuxdriver.com>
References: <1291850970-7190-1-git-send-email-peterhuewe@gmx.de> <201012192000.14969.PeterHuewe@gmx.de> <AANLkTi=gqimS5n6J6GXcZA_W1JHZ8yHJHAKqP=dDmN0Z@mail.gmail.com>
In-Reply-To: <AANLkTi=gqimS5n6J6GXcZA_W1JHZ8yHJHAKqP=dDmN0Z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012201809.41269.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 20 Dezember 2010, 15:46:02 schrieb Sedat Dilek:
> > Added Stephen Rothwell on CC, maybe he can apply it directly to
> > linux-next ;)
> > 
> > Peter
> 
> I do not think this will happen for a "as-warning-classified" patch.

On arm and avr32 it is not only a warning but an error instead!

-> so the patch fixes an error / build failure which imho is quite an 
important issue.

You can see the errors in Ellerman's build farm.

http://kisskb.ellerman.id.au/kisskb/buildresult/3652816/
http://kisskb.ellerman.id.au/kisskb/buildresult/3664077/
http://kisskb.ellerman.id.au/kisskb/buildresult/3652972/
http://kisskb.ellerman.id.au/kisskb/buildresult/3664113/

As it is an error for arm and avr32 maybe it should go through their trees 
instead?

Peter

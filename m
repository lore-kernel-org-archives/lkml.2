Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1BANHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:07:23 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:54154 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab1BANHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:07:22 -0500
Message-ID: <1296565633.4d4805812c3f5@imp.free.fr>
Date: Tue, 01 Feb 2011 14:07:13 +0100
From: castet.matthieu@free.fr
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: matthieu castet <castet.matthieu@free.fr>, Ingo Molnar <mingo@elte.hu>,
        Kees Cook <kees.cook@canonical.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [BUG] broken ebba638ae723d8a8fc2f7abce5ec18b688b791d7
References: <4D41E86D.8060205@free.fr> <20110131213847.GF4557@outflux.net> <4D474194.2000709@free.fr> <201102010017.40986.rjw@sisk.pl>
In-Reply-To: <201102010017.40986.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 93.1.148.69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "Rafael J. Wysocki" <rjw@sisk.pl>:

> On Tuesday, February 01, 2011, matthieu castet wrote:
> Well, in my not so humble opinion the amount of random fixes required by the
> entire NX protection of kernel "data" pages is simply unacceptable.

What's the relation between this bug and NX protection of kernel "data" ?

Matthieu

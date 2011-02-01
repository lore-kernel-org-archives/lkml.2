Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab1BASvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:51:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33300 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab1BASvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:51:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: castet.matthieu@free.fr
Subject: Re: [BUG] broken ebba638ae723d8a8fc2f7abce5ec18b688b791d7
Date: Tue, 1 Feb 2011 19:50:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Kees Cook <kees.cook@canonical.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
References: <4D41E86D.8060205@free.fr> <201102010017.40986.rjw@sisk.pl> <1296565633.4d4805812c3f5@imp.free.fr>
In-Reply-To: <1296565633.4d4805812c3f5@imp.free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102011950.49153.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 01, 2011, castet.matthieu@free.fr wrote:
> Quoting "Rafael J. Wysocki" <rjw@sisk.pl>:
> 
> > On Tuesday, February 01, 2011, matthieu castet wrote:
> > Well, in my not so humble opinion the amount of random fixes required by the
> > entire NX protection of kernel "data" pages is simply unacceptable.
> 
> What's the relation between this bug and NX protection of kernel "data" ?

Sorry, I confused threads.

Rafael

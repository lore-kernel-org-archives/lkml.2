Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0LISmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:42:49 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:56875 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751872Ab0LISms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:42:48 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1890fpOf309FdYtRsJKMeH9KC9IVbssCdC7DKkMev
	5cAjeVhcWQYbQ/
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH] avr32: Fix build failure conflicting types for 'sys_execve'
Date: Thu, 9 Dec 2010 19:42:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.4.5; x86_64; ; )
Cc: "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
References: <1291850373-6955-1-git-send-email-peterhuewe@gmx.de> <20101209182132.GB24175@kroah.com>
In-Reply-To: <20101209182132.GB24175@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012091942.36508.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is _not_ how to get stuff into the stable kernel tree, sorry.
Sorry about that - still learning ;) - thanks for your patience.

> Please read Documentation/stable_kernel_rules.txt for how to do so.
 It states: "You must note the upstream commit ID in the changelog of your 
submission." - where do I get the ID from?

> Care to resend?
Will do.
Or should I rather drop the patch and we wait on Hans-Christian's patch(es)?

Thanks,
Peter


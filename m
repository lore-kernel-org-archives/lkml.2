Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab1CRMH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 08:07:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62373 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab1CRMHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 08:07:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Subject: Re: [PATCH v3 7/7] tty: add pruss SUART driver
Date: Fri, 18 Mar 2011 13:07:12 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        "Andrew Morton \(commit_signer:1/4=25%\)" <akpm@linux-foundation.org>,
        "Randy Dunlap \(commit_signer:1/4=25%\)" <randy.dunlap@oracle.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com> <1299592667-21367-8-git-send-email-subhasish@mistralsolutions.com> <02A821E977914EF6B7B4BD36F07C1A2A@subhasishg>
In-Reply-To: <02A821E977914EF6B7B4BD36F07C1A2A@subhasishg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103181307.12699.arnd@arndb.de>
X-Provags-ID: V02:K0:AVcdZlIslExT+GhUyI6hXYZY82Z3amlGlWXDYnNQ91B
 WkZqXaKPzbtnegFlUU56nUFSiJemCtgfUosOewkVAHpKuSpd/A
 nDgNIgYpTQe91Rqq2RwZPwveXhwcvJ7FQvgW+/PENnvIGLBvdC
 AuZhAC5CYVuIIqv2Y8V6tDLfPA8v+Kc9GUIA+1VGAWHJS8NkHn
 pMeOxx9FZJ1jDjkKP8RLw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011, Subhasish Ghosh wrote:
> Hi Greg/Alan,
> 
> Any comments regarding this driver.
> 

I already did a review of the base MFD driver that you have not replied
to yet. A number of the points I brought up in that review and in my
review of the pruss CAN driver also apply to this one. Please post
cleaned-up versions of all those drivers, and I'll have another look.

	Arnd

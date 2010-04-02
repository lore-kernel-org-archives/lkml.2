Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab0DBVgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 17:36:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35050
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328Ab0DBVg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 17:36:26 -0400
Date: Fri, 02 Apr 2010 14:36:27 -0700 (PDT)
Message-Id: <20100402.143627.11964909.davem@davemloft.net>
To: nix@esperi.org.uk
Cc: linux-kernel@vger.kernel.org, nhorman@redhat.com
Subject: Re: unhelpful and somewhat scary r8169 boot message in 2.6.33.2
 regarding a security fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <87iq89q3v2.fsf@spindle.srvr.nix>
References: <87iq89q3v2.fsf@spindle.srvr.nix>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nix <nix@esperi.org.uk>
Date: Fri, 02 Apr 2010 16:19:13 +0100

> So I was doing a test-boot of 2.6.33.2 to see if my hang-on-suspend
> Radeon DRM regression (fdo bug 26872) was cured (it wasn't), when a
> new message appeared at bootup, the second of those below:
> 
> [    8.766768] r8169: fastnet: link up
> [    8.791231] WARNING! Changing of MTU on this NICMay lead to frame reception errors!
> 
> (which appeared when I set the MTU on my r8169 to 7200.)
> 
> Not only is this message plainly misformatted :)

Formating has been fixed in the net-2.6 tree yesterday.

> but it does not explain *why* changing the MTU is suddenly so bad,
> when it's worked forever before now without flaw, with no sign of
> any sort of corruption. Why should we be confined to non-jumbo
> frames? What are the effects if we do change MTU?

Have a look at CVE-2009-4537

It's a remotely exploitable memory corruptor and potential
root hole.

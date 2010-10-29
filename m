Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab0J2OOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:14:37 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:44521 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757923Ab0J2OOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:14:35 -0400
X-SpamScore: -11
X-BigFish: VS-11(z3b68iz1432N98dNzz1202hzzz2dh2a8h66h)
X-Spam-TCS-SCL: 5:0
Message-ID: <4CCAD6C5.5020102@freescale.com>
Date: Fri, 29 Oct 2010 09:14:29 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.13) Gecko/20101013 Fedora/2.0.8-2.fc13 SeaMonkey/2.0.8
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: gregkh <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Writing a console/tty driver -- how to use tty_port?
References: <4CC893CD.7020701@freescale.com> <20101027231948.5e62dd09@lxorguk.ukuu.org.uk> <4CC9D074.3060108@freescale.com> <4CCAD244.3060600@freescale.com>
In-Reply-To: <4CCAD244.3060600@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2010 14:15:02.0985 (UTC) FILETIME=[ADBB0390:01CB7773]
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> I've done a little more debugging, and it's even stranger than I thought.  The
> console is only half missing.
> 
> What's missing is my shell prompt, and a few other things.  I can type in
> commands, though.  The prompt returns, however, if I 'cd' to the root direcetory.

Never mind, I figure it out.  My console device was silently rejecting any
writes larger than 16 bytes.

Sorry for the noise.  I know your inboxes must be always full.

-- 
Timur Tabi
Linux kernel developer at Freescale


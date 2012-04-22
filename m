Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab2DVRHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 13:07:48 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:43039 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab2DVRHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 13:07:47 -0400
Message-ID: <4F943AE1.5050207@msgid.tls.msk.ru>
Date: Sun, 22 Apr 2012 21:07:45 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: hibernate a system booted from external USB drive - is it posible
 ?
References: <201204221849.31198.toralf.foerster@gmx.de>
In-Reply-To: <201204221849.31198.toralf.foerster@gmx.de>
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.04.2012 20:49, Toralf Förster wrote:
> I wonder, whether it is expect to work with current stable kernel 3.3.2 or 
> not. Seems not to work here (s2ram works fine).
> Hibernate however writes data to the swap partition, but during wakeup I get :
> 
> kernel: PM: Hibernation image partition 8:6 present
> kernel: PM: Looking for hibernation image.
> kernel: PM: Image not found (code -22)
> kernel: PM: Hibernation image not present or could not be loaded. 

This is entirely an initramfs issue/question.  The device should be
present in early userspace when it attempts to resume.  Also, s2ram &Co
may not be prepared for changing device name/node.

I've a system with only one "drive" being an usb flash stick (Sandisk
Cruzer Fit).  This system is able to hibernate and resume just fine,
but I don't do it often (it is our router).

/mjt

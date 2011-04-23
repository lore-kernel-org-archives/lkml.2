Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab1DWBqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 21:46:15 -0400
Received: from snt0-omc3-s29.snt0.hotmail.com ([65.55.90.168]:24622 "EHLO
	snt0-omc3-s29.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757165Ab1DWBqO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 21:46:14 -0400
Message-ID: <SNT125-W632CB71E47020C0C05FBDCC3940@phx.gbl>
X-Originating-IP: [50.47.160.44]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <chris@csamuel.org>
CC: <alan@lxorguk.ukuu.org.uk>, <hpa@zytor.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on
 quad Pentium Pro system
Date: Fri, 22 Apr 2011 18:46:13 -0700
Importance: Normal
In-Reply-To: <201104231135.54966.chris@csamuel.org>
References: <201104222333.25546.chris@csamuel.org>
 <201104231016.23579.chris@csamuel.org>
 <SNT125-W638277FA9F3B49B316DC9FC3940@phx.gbl>,<201104231135.54966.chris@csamuel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Apr 2011 01:46:14.0695 (UTC) FILETIME=[3B160370:01CC0158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If it was really BIOS-e801 and not BIOS-88 returning this, looks like this is probably a kernel bug in the parsing of the results.
> > This would be easy to diagnose with DOS DEBUG with no himem.sys
> > loaded.
>
> Would be happy to try with some instructions if it would help.
Enter these instructions using the A command and execute with the T command:
mov AX, E801
INT 15
INT 3
And provide the results of the AX, BX, CX, and DX registers after the INT 15h.
 
Yuhong Bao 		 	   		  
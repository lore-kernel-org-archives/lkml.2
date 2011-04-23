Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab1DWCbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 22:31:25 -0400
Received: from snt0-omc2-s24.snt0.hotmail.com ([65.55.90.99]:21342 "EHLO
	snt0-omc2-s24.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757174Ab1DWCbY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 22:31:24 -0400
Message-ID: <SNT125-W1505AE2FEED327C90DFAEC3940@phx.gbl>
X-Originating-IP: [50.47.160.44]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@zytor.com>
CC: <chris@csamuel.org>, <alan@lxorguk.ukuu.org.uk>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on
 quad Pentium Pro system
Date: Fri, 22 Apr 2011 19:31:23 -0700
Importance: Normal
In-Reply-To: <4DB238BB.2010204@zytor.com>
References: <201104222333.25546.chris@csamuel.org>
 <201104231016.23579.chris@csamuel.org>
 <SNT125-W638277FA9F3B49B316DC9FC3940@phx.gbl>,<201104231135.54966.chris@csamuel.org>
 <SNT125-W632CB71E47020C0C05FBDCC3940@phx.gbl>,<4DB238BB.2010204@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Apr 2011 02:31:24.0718 (UTC) FILETIME=[8A62B4E0:01CC015E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Executing these from DOS DEBUG won't give you real results, because DOS
> intercepts this call.
Which is why I said to do it without himem.sys loaded in a previous email.
Yuhong Bao
 		 	   		  
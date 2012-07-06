Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab2GFCsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 22:48:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58840 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454Ab2GFCsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 22:48:32 -0400
MIME-Version: 1.0
In-Reply-To: <CA+fU7qehx6Jjb0ZWNrh+bh6SYCKLVWZDd7iLnsC=hDVqqFd74Q@mail.gmail.com>
References: <CA+fU7qen=cwc1vMY1bv21_0GuNKXPQZXsQLVszYG1WG_r1XUGA@mail.gmail.com>
 <20120524123116.GA4048@alberich.amd.com> <CA+fU7qfPznJpRABC4Z=xmRZW6p5Mw3dFLBySk9HuPnaCYMMnEg@mail.gmail.com>
 <20120529140940.GA10421@alberich.amd.com> <CA+fU7qdKYA3KJr3xET_evO_1ztSKh0K0csn5Coro7Mkv_my+eg@mail.gmail.com>
 <20120530124333.GA3008@alberich.amd.com> <CA+fU7qehx6Jjb0ZWNrh+bh6SYCKLVWZDd7iLnsC=hDVqqFd74Q@mail.gmail.com>
From: Comrade DOS <suloevdmitry@gmail.com>
Date: Fri, 6 Jul 2012 09:47:51 +0700
Message-ID: <CA+fU7qcNe7d1BPWQ9jYYL7erByXAEgYzyFX1+R_ceXEjHxC3ew@mail.gmail.com>
Subject: Fwd: PROBLEM: Performance drop
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Comrade DOS <suloevdmitry@gmail.com>
Date: 2012/6/2
Subject: Re: PROBLEM: Performance drop
To: Andreas Herrmann <herrmann.der.user@googlemail.com>,
linux-kernel@vger.kernel.org


Sorry for delay.

> If reverting the patch helps we have to take a closer look at your
> ACPI tables.  So can you please do a

It really helps! After reverting of this commit all problem go away.

All files what you need in attachment.

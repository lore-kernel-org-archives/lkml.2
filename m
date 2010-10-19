Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0JSP7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:59:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55190 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753608Ab0JSP7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:59:42 -0400
Date: Tue, 19 Oct 2010 11:59:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Mickler <florian@mickler.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, O01eg <O01eg@yandex.ru>
Subject: Re: [linux-pm] 2.6.36-rc8-git3: Reported regressions 2.6.34 -> 2.6.35
In-Reply-To: <1SnkuNVk0vO.A.E9E.Qx1uMB@chimera>
Message-ID: <Pine.LNX.4.44L0.1010191157070.1786-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Oct 2010, Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19302
> Subject		: PROBLEM: kernel crash on USB-modem (Huawei E1750) hangup.
> Submitter	: O01eg <O01eg@yandex.ru>
> Date		: 2010-09-26 19:50 (22 days old)
> Message-ID	: <op.vjnn1up1yohvy1@localhost>
> References	: http://marc.info/?l=linux-kernel&m=128553111709569&w=2

This does not appear to be a regression.  The bug report states that
the problem occurs in 2.6.34 and 2.6.36-rc5 and that no other kernels
were tested.

Alan Stern


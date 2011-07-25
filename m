Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab1GYIIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:08:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35957 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab1GYIIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:08:14 -0400
MIME-Version: 1.0
In-Reply-To: <20110724130336.GA2116@ime.usp.br>
References: <20110724130336.GA2116@ime.usp.br>
Date: Mon, 25 Jul 2011 09:08:12 +0100
Message-ID: <CAPM=9txTVVxvv85kcZqBVjmpVK1zsAvVarLv1Sm7viwfF+ZYyA@mail.gmail.com>
Subject: Re: [REGRESSION] [BISECTED] Unable to use 3D with Radeon 2100 and UI
 freezes with Firefox
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/24 Rogério Brito <rbrito@ime.usp.br>:
> Dear Thomas and other people,
>
> After experiencing problems with many post 2.6.38 kernels with X when I used
> Firefox to see any webpage that used some of the new HTML5 features (Firefox
> freeze completely X and I could only log in remotely with SSH), I took some
> time to see where things went wrong and, to cut a long story short, I
> bisected the kernel and I found that a commit of yours was the first one
> that introduced a problem with my system:

> `----
>
> Here I have the dmesg output slightly edited with the points that I think
> that are the most relevant to the problem. Please note that my understanding
> of devices/hardware is next to nothing and I may have cut important parts.

Can you attach /proc/interrupts as well please.

Dave.

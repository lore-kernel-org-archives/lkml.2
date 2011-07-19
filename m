Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab1GSFiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 01:38:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49033 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab1GSFit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 01:38:49 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.253.223]
In-Reply-To: <20110609171210.GB3877@ucw.cz>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-8-git-send-email-ohad@wizery.com> <20110609171210.GB3877@ucw.cz>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 19 Jul 2011 08:38:28 +0300
Message-ID: <CAK=WgbY=gay-mLKhssinPhv1ic6FszGoLyLo9E6y7=3QOLx2FQ@mail.gmail.com>
Subject: Re: [RFC 7/8] drivers: introduce rpmsg, a remote-processor messaging bus
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Thu, Jun 9, 2011 at 8:12 PM, Pavel Machek <pavel@ucw.cz> wrote:
> So this is basically networking... right? Why not implement it as
> sockets? (accept, connect, read, write)?

This patch focuses on adding the core rpmsg kernel infrastructure. The
next step, after getting the basic stuff in, would be adding rpmsg
drivers, and exposing user space API.

For some use cases, where userland talks directly with remote entities
(and otherwise requires no kernel involvement besides exposing the
transport), socket API is very nice as it's flexible and prevalent.

We already have several rpmsg drivers and a rpmsg-based socket API
implementation too, but we'll get to it only after the core stuff gets
in.

Thanks,
Ohad.

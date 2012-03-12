Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2CLI3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 04:29:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54268 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab2CLI30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 04:29:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120308184954.GA1275@kroah.com>
References: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>
	<20120308184954.GA1275@kroah.com>
Date: Mon, 12 Mar 2012 09:29:25 +0100
Message-ID: <CACRpkdayeUPFCzcKftAnkkLkB5QHhghtSxb4=uziDLDgGnsyGw@mail.gmail.com>
Subject: Re: [PATCH] Clear previous interrupts after fifo is disabled
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chanho Min <chanho0207@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Kim, Jong-Sung" <neidhard.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 7:49 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:

> Can someone, if this is still needed, and everyone agrees on how to
> solve it, please send me the needed fix?

I've send a patch combining the probe() and startup() fixes from Russell
with the latest patch from Jong-Sung Kim into what may very well
be the silver bullet.
Subject "serial: PL011: clear pending interrupts"

Yours,
Linus Walleij

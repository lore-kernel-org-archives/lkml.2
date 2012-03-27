Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab2C0HHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:07:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:32897 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab2C0HHX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:07:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120326203209.GA8182@mail.gnudd.com>
References: <20120326203209.GA8182@mail.gnudd.com>
Date: Tue, 27 Mar 2012 09:07:22 +0200
Message-ID: <CACRpkdZXhJn241n8wMU8yUFwL7mpWrV3hP6C-_r_P1GGWgd_Og@mail.gmail.com>
Subject: Re: [PATCH] amba-pl011: fix panic introduced by "clear pending interrupts"
From: Linus Walleij <linus.walleij@linaro.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 10:32 PM, Alessandro Rubini <rubini@gnudd.com> wrote:

> patch 9b96fba, currently in linux-next, clears interrupts using
> uap->port.membase that has not been assigned.  My x86 system,
> that uses a pci-to-amba bridge, panics with a message like:
>
>   BUG: unable to handle kernel NULL pointer dereference at 00000038
>   IP: [<c12c85ed>] pl011_probe+0x119/0x303
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>

Yep I know, already sent the remedy, just waiting for Greg to pick it up:
http://marc.info/?l=linux-serial&m=133235774423240&w=2

But thanks for the quick attention :-)

Yours,
Linus Walleij

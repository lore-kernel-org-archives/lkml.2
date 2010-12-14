Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab0LNE7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 23:59:00 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:43090 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757986Ab0LNE67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 23:58:59 -0500
Date: Tue, 14 Dec 2010 10:28:31 +0530
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Luotao Fu <l.fu@pengutronix.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/20] mfd: stmpe: irq_data conversion.
Message-ID: <20101214045830.GA27355@bnru05.bnr.st.com>
References: <cover.1292241952.git.buytenh@wantstofly.org>
 <20101213123102.GU15575@mail.wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101213123102.GU15575@mail.wantstofly.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 13:31:02 +0100, Lennert Buytenhek wrote:
> Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
> ---
>  drivers/mfd/stmpe.c |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)

Thanks, but Mark Brown already sent in similar patches to convert this driver
and mfd/tc35892.c.

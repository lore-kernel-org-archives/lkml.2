Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab0INDtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 23:49:23 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:35656 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753071Ab0INDtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 23:49:22 -0400
Date: Tue, 14 Sep 2010 09:19:08 +0530
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Luotao Fu <l.fu@pengutronix.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: stmpe: fix error path
Message-ID: <20100914034907.GA18875@bnru01.bnr.st.com>
References: <1284317840-5131-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1284317840-5131-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 20:57:19 +0200, Vasiliy Kulikov wrote:
> Free allocated memory.  Call stmpe_disable() if it was enabled.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Acked-by: Rabin Vincent <rabin.vincent@stericsson.com>

Thanks,
Rabin

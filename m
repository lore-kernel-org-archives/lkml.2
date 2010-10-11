Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab0JKPdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 11:33:38 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38947 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab0JKPdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 11:33:37 -0400
Date: Tue, 12 Oct 2010 00:33:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: boards/mach-x3proto: gpio: fix error handling code
Message-ID: <20101011153328.GB12338@linux-sh.org>
References: <1286731708-17822-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286731708-17822-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 09:28:27PM +0400, Vasiliy Kulikov wrote:
> Checks for (irq < 0) and (ilsel < 0) didn't make sense since they were
> unsigned.  Made them signed.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Applied, thanks.

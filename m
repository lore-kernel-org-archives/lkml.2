Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab1DKTCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 15:02:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60858 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab1DKTCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 15:02:16 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
cc: andy@greyhouse.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] bonding:delete two unused variables
In-reply-to: <cover.1302509480.git.panweiping3@gmail.com>
References: <cover.1302509480.git.panweiping3@gmail.com>
Comments: In-reply-to =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= <panweiping3@gmail.com>
   message dated "Mon, 11 Apr 2011 16:17:23 +0800."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Apr 2011 12:02:09 -0700
Message-ID: <30720.1302548529@death>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>I found that variable alb_timer and rlb_interval_counter in struct
>alb_bond_info are not used by other codes any more, so delete them.
>
>Weiping Pan(潘卫平) (2):
>  bonding:delete unused alb_timer
>  bonding:delete unused rlb_interval_counter

	For both patches.

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>


> drivers/net/bonding/bond_alb.h |    2 --
> 1 files changed, 0 insertions(+), 2 deletions(-)
>
>-- 
>1.7.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe netdev" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

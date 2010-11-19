Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab0KSAlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:41:53 -0500
Received: from mail.vyatta.com ([76.74.103.46]:54181 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711Ab0KSAlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:41:52 -0500
Date: Thu, 18 Nov 2010 16:41:50 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Samuel Ortiz <samuel@sortiz.org>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        irda-users@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SuperH IrDA: correct Baud rate error correction
Message-ID: <20101118164150.22aa7e16@nehalam>
In-Reply-To: <20101119012402.43e9aa61@absol.kitzblitz>
References: <20101119012402.43e9aa61@absol.kitzblitz>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 01:24:02 +0100
Nicolas Kaiser <nikai@nikai.net> wrote:

>  	u32 rate_err_array[] = {
> -		0000, 0625, 1250, 1875,
> +		   0,  625, 1250, 1875,
>  		2500, 3125, 3750, 4375,
>  		5000, 5625, 6250, 6875,
>  		7500, 8125, 8750, 9375,

While you are at it make that table const.

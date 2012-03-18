Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab2CRB7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 21:59:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:54694 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2CRB7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 21:59:17 -0400
Message-ID: <1332035872.2902.1.camel@kubuntu-11-10>
Subject: Re: [PATCH 2/2] drivers: net: Remove unnecessary line continuations
From: Geoff Levand <geoff@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        Jens Osterkamp <jens@de.ibm.com>, Samuel Ortiz <samuel@sortiz.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cbe-oss-dev@lists.ozlabs.org
Date: Sat, 17 Mar 2012 18:57:52 -0700
In-Reply-To: <67ad900b6f6451b5b28b004def471c9a41b1ee24.1332011552.git.joe@perches.com>
References: <1d738d4a4dd61978f969ed4a43f2dd3717f51a19.1332011552.git.joe@perches.com>
	 <67ad900b6f6451b5b28b004def471c9a41b1ee24.1332011552.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-17 at 12:14 -0700, Joe Perches wrote:
> Line continuations are error prone so just remove them.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c |    3 +--

Looks OK for ps3_gelic_net.  Thanks.

Acked-by: Geoff Levand <geoff@infradead.org>


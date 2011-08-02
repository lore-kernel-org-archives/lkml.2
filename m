Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab1HBNzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 09:55:38 -0400
Received: from mail.southpole.se ([193.12.106.18]:46776 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1HBNzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 09:55:33 -0400
Subject: Re: [PATCH 10/11] arch/openrisc/mm/init.c: trivial: use BUG_ON
From: Jonas Bonn <jonas@southpole.se>
To: Julia Lawall <julia@diku.dk>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux@openrisc.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <1312281304-11847-11-git-send-email-julia@diku.dk>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
	 <1312281304-11847-11-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole AB
Date: Tue, 02 Aug 2011 15:55:44 +0200
Message-ID: <1312293344.4723.157.camel@crucifix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2011-08-02 at 12:35 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use BUG_ON(x) rather than if(x) BUG();
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@ identifier x; @@
> -if (x) BUG();
> +BUG_ON(x);
> 
> @@ identifier x; @@
> -if (!x) BUG();
> +BUG_ON(!x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 

Will apply.  Thanks.

Best regards,
Jonas



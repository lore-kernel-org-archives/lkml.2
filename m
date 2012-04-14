Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab2DNTGM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 15:06:12 -0400
Received: from intermatrixgroup.ru ([195.178.208.66]:48529 "EHLO
	tservice.net.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754322Ab2DNTGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 15:06:10 -0400
Date: Sat, 14 Apr 2012 23:06:02 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Markus Franke <franm@hrz.tu-chemnitz.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] w1: w1_ds28e04: unlock on error path in
 w1_f1C_write_pio()
Message-ID: <20120414190602.GB6482@ioremap.net>
References: <20120413133906.GB26645@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413133906.GB26645@elgon.mountain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 04:39:06PM +0300, Dan Carpenter (dan.carpenter@oracle.com) wrote:
> We should unlock here before returning.

Looks good, thank you, Dan

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Greg, please pull it into your tree
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov

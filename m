Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab2CCSo1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 13:44:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:34352 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2CCSo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 13:44:26 -0500
Message-ID: <4F526681.9040503@kernel.dk>
Date: Sat, 03 Mar 2012 19:44:17 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] block, sx8: fix pointer math issue getting fw version
References: <20120302190042.GB3951@elgon.mountain> <4F51C103.507@kernel.dk> <4F525086.60103@pobox.com>
In-Reply-To: <4F525086.60103@pobox.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-03 18:10, Jeff Garzik wrote:
> On 03/03/2012 01:58 AM, Jens Axboe wrote:
>> On 2012-03-02 20:00, Dan Carpenter wrote:
>>> "mem" is type u8.  We need parenthesis here or it screws up the pointer
>>> math probably leading to an oops.
>>
>> Applied, thanks Dan. I have marked it stable, too.
> 
> Please add Acked-by: Jeff Garzik <jgarzik@redhat.com>
> 
> It is rather obscure hardware, but I do still maintain the driver :)

Sure, added. I still have one in my drawer, btw, but it hasn't been
hooked up in ages :-)

-- 
Jens Axboe


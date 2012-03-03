Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab2CCG6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 01:58:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45656 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2CCG6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 01:58:17 -0500
Message-ID: <4F51C103.507@kernel.dk>
Date: Sat, 03 Mar 2012 07:58:11 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] block, sx8: fix pointer math issue getting fw version
References: <20120302190042.GB3951@elgon.mountain>
In-Reply-To: <20120302190042.GB3951@elgon.mountain>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-02 20:00, Dan Carpenter wrote:
> "mem" is type u8.  We need parenthesis here or it screws up the pointer
> math probably leading to an oops.

Applied, thanks Dan. I have marked it stable, too.

-- 
Jens Axboe


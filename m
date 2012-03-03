Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2CCRKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 12:10:34 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64211 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab2CCRKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 12:10:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jgpobox@gmail.com designates 10.52.24.233 as permitted sender) smtp.mail=jgpobox@gmail.com; dkim=pass header.i=jgpobox@gmail.com
Message-ID: <4F525086.60103@pobox.com>
Date: Sat, 03 Mar 2012 12:10:30 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Dan Carpenter <dan.carpenter@oracle.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] block, sx8: fix pointer math issue getting fw version
References: <20120302190042.GB3951@elgon.mountain> <4F51C103.507@kernel.dk>
In-Reply-To: <4F51C103.507@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2012 01:58 AM, Jens Axboe wrote:
> On 2012-03-02 20:00, Dan Carpenter wrote:
>> "mem" is type u8.  We need parenthesis here or it screws up the pointer
>> math probably leading to an oops.
>
> Applied, thanks Dan. I have marked it stable, too.

Please add Acked-by: Jeff Garzik <jgarzik@redhat.com>

It is rather obscure hardware, but I do still maintain the driver :)




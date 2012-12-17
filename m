Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab2LQPSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:18:37 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52216
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681Ab2LQPSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:18:36 -0500
Message-ID: <50CF37C6.1080108@kernel.dk>
Date: Mon, 17 Dec 2012 16:18:30 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: Tejun Heo <tj@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/15] block,elevator: use new hashtable implementation
References: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com> <1355756497-15834-7-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1355756497-15834-7-git-send-email-sasha.levin@oracle.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-17 16:01, Sasha Levin wrote:
> Switch elevator to use the new hashtable implementation. This reduces the
> amount of generic unrelated code in the elevator.
> 
> This also removes the dymanic allocation of the hash table. The size
> of the table is constant so there's no point in paying the price of an
> extra dereference when accessing it.
> 
> This patch depends on d9b482c ("hashtable: introduce a small and naive
> hashtable") which was merged in v3.6.

It's a convenient cleanup. I will queue it up for 3.9, it's too late for
3.8 at this point.

-- 
Jens Axboe


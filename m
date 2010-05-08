Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab0EHHFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 03:05:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39397 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab0EHHFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 03:05:51 -0400
Message-ID: <4BE50D37.7020603@cs.helsinki.fi>
Date: Sat, 08 May 2010 10:05:27 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: ngupta@vflare.org
CC: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Minchan Kim <minchan.kim@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data from compressed memory
 (v2)
References: <1273217107-2023-1-git-send-email-ngupta@vflare.org> <20100507155504.10532b3e.akpm@linux-foundation.org> <4BE504AD.4030807@cs.helsinki.fi> <4BE50AA3.6040806@vflare.org>
In-Reply-To: <4BE50AA3.6040806@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta wrote:
> Its not debug code. This ioctl is how we send stats about given ramzswap
> device to userspace: rzscontrol /dev/ramzswap --stats, invokes this ioctl
> and prints the stats. I will add comments to this part to make it clear.

Another option would be sysfs if you want the stats to always be available.

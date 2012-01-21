Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab2AUMqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 07:46:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48550 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2AUMqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 07:46:18 -0500
Message-ID: <4F1AB392.20604@kernel.dk>
Date: Sat, 21 Jan 2012 13:46:10 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org,
        dm-devel@redhat.com
Subject: Re: BUG: spinlock trylock failure on UP on CPU#0, vgchange/936
References: <alpine.DEB.2.01.1201180009520.2895@trent.utfs.org> <alpine.DEB.2.01.1201210341430.2895@trent.utfs.org>
In-Reply-To: <alpine.DEB.2.01.1201210341430.2895@trent.utfs.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-21 12:42, Christian Kujau wrote:
> On Wed, 18 Jan 2012 at 00:18, Christian Kujau wrote:
>> today's git checkout boots fine on powerpc32, but has this message during 
>> bootup:
>>
>> BUG: spinlock trylock failure on UP on CPU#0, vgchange/936
>>  lock: ef32a9f8, .magic: dead4ead, .owner: vgchange/936, .owner_cpu: 0
>> Call Trace:
> 
> Still happening with 3.3.0-rc1.

Can you try and pull:

git://git.kernel.dk/linux-block.git for-linus

and see if it helps?

-- 
Jens Axboe


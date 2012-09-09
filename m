Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab2IIKmO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 06:42:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55888 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2IIKmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 06:42:13 -0400
Message-ID: <504C727E.1030309@kernel.dk>
Date: Sun, 09 Sep 2012 12:42:06 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT] floppy, pktcdvd
References: <alpine.LNX.2.00.1209041134240.23857@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1209041134240.23857@pobox.suse.cz>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-04 11:39, Jiri Kosina wrote:
> Jens,
> 
> please consider pulling from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git for-jens
> 
> (based on 'master' of your linux-block.git) to receive the changes below.
> 
> There are a couple of fixes (mostly clenaups) to floppy driver from Herton 
> Ronaldo Krzesinski and Ben Hutchings.

Thanks, pulled.

> Apart from that, Peter is giving up on pktcdvd maintainer ship, so I 
> offered to take it, cosidering that I have the necessary hardware and it's 
> a very low-traffic code anyway.

Excellent, glad that someone is keeping it alive.

-- 
Jens Axboe


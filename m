Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab2AVMKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 07:10:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:46495 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2AVMJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 07:09:59 -0500
Message-ID: <4F1BFC94.9000306@kernel.dk>
Date: Sun, 22 Jan 2012 13:09:56 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org,
        dm-devel@redhat.com
Subject: Re: BUG: spinlock trylock failure on UP on CPU#0, vgchange/936
References: <alpine.DEB.2.01.1201180009520.2895@trent.utfs.org> <alpine.DEB.2.01.1201210341430.2895@trent.utfs.org> <4F1AB392.20604@kernel.dk> <alpine.DEB.2.01.1201211430340.2895@trent.utfs.org> <4F1BE548.3000800@kernel.dk> <alpine.DEB.2.01.1201220233260.2895@trent.utfs.org>
In-Reply-To: <alpine.DEB.2.01.1201220233260.2895@trent.utfs.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-22 11:36, Christian Kujau wrote:
> On Sun, 22 Jan 2012 at 11:30, Jens Axboe wrote:
>> What about with this on top?
> 
> Will try. A compile on this box takes almost two hours (PowerBook G4, 
> throttled to 70MHz), would it be enough to remove the block/*.o files and 
> continue from there?

Yes, just recompiling block/*.o is enough.

-- 
Jens Axboe


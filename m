Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab2AVKgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 05:36:48 -0500
Received: from trent.utfs.org ([194.246.123.103]:49619 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2AVKgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 05:36:47 -0500
Date: Sun, 22 Jan 2012 02:36:38 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Jens Axboe <axboe@kernel.dk>
cc: LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org,
        dm-devel@redhat.com
Subject: Re: BUG: spinlock trylock failure on UP on CPU#0, vgchange/936
In-Reply-To: <4F1BE548.3000800@kernel.dk>
Message-ID: <alpine.DEB.2.01.1201220233260.2895@trent.utfs.org>
References: <alpine.DEB.2.01.1201180009520.2895@trent.utfs.org> <alpine.DEB.2.01.1201210341430.2895@trent.utfs.org> <4F1AB392.20604@kernel.dk> <alpine.DEB.2.01.1201211430340.2895@trent.utfs.org> <4F1BE548.3000800@kernel.dk>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jan 2012 at 11:30, Jens Axboe wrote:
> What about with this on top?

Will try. A compile on this box takes almost two hours (PowerBook G4, 
throttled to 70MHz), would it be enough to remove the block/*.o files and 
continue from there?

Thanks,
Christian.
-- 
BOFH excuse #17:

fat electrons in the lines

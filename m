Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab0ITRXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:23:31 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33601 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023Ab0ITRXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:23:30 -0400
Message-ID: <4C979896.6050900@kernel.dk>
Date: Mon, 20 Sep 2010 19:23:34 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/3 RESEND] BDI handling fixes
References: <1284997471-9850-1-git-send-email-jack@suse.cz>
In-Reply-To: <1284997471-9850-1-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-20 17:44, Jan Kara wrote:
>   Hi,
> 
>   I resend this series because I've messed up Jens' address in the original
> posting. Jens, would you please include these fixes in your tree? Thanks.
> The series of these three patches fixes the warning in __mark_inode_dirty()
> which happens when I do e.g. touch /dev/zero.

Thanks, I'll commit for .37 and tag the for stable.

-- 
Jens Axboe


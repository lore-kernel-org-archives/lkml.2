Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab2KMRiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:38:19 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33507 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2KMRiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:38:17 -0500
Date: Tue, 13 Nov 2012 09:38:11 -0800
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH v3 1/2] sg_io: pass request_queue to blk_verify_command
Message-ID: <20121113173811.GA19014@mtj.dyndns.org>
References: <1352827513-29890-1-git-send-email-pbonzini@redhat.com>
 <1352827513-29890-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352827513-29890-2-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 06:25:12PM +0100, Paolo Bonzini wrote:
> Adjust the blk_verify_command function to let it look at per-queue
> data.  This will be done in the next patch.
> 
> Cc: linux-scsi@vger.kernel.org
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Ric Wheeler <rwheeler@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

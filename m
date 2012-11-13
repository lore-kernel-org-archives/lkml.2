Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab2KMRil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:38:41 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33507 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab2KMRij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:38:39 -0500
Date: Tue, 13 Nov 2012 09:38:34 -0800
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH v3 2/2] sg_io: introduce unpriv_sgio queue flag
Message-ID: <20121113173834.GB19014@mtj.dyndns.org>
References: <1352827513-29890-1-git-send-email-pbonzini@redhat.com>
 <1352827513-29890-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352827513-29890-3-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 06:25:13PM +0100, Paolo Bonzini wrote:
> This queue flag will let unprivileged users send any SG_IO command to the
> device, without any filtering.  This makes it possible to run a program
> where you want to access the full range of SCSI commands, while still
> running as confined as possible.  With this patch, such a program will
> not need the CAP_SYS_RAWIO capability anymore, and will also not be
> able to send SCSI commands to a partition (which would affect the full
> disk).
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

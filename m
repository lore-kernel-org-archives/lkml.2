Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965227Ab2CUKJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:09:47 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54895 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965181Ab2CUKJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:09:45 -0400
Message-ID: <1332324581.2909.38.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] st: fix race in st_scsi_execute_end
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Petr Uzel <petr.uzel@suse.cz>
Cc: linux-kernel@vger.kernel.org, Willem Riede <osst@riede.org>, jack@suse.cz,
        linux-scsi@vger.kernel.org, juergen.gross@ts.fujitsu.com
Date: Wed, 21 Mar 2012 10:09:41 +0000
In-Reply-To: <20111021113108.GA26181@foxbat.suse.cz>
References: <20111021113108.GA26181@foxbat.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-21 at 13:31 +0200, Petr Uzel wrote:
> The call to complete() in st_scsi_execute_end() wakes up sleeping thread
> in write_behind_check(), which frees the st_request, thus invalidating
> the pointer to the associated bio structure, which is then passed to the
> blk_rq_unmap_user(). Fix by storing pointer to bio structure into
> temporary local variable.
> 
> This bug is present since at least linux-2.6.32.

This patch isn't applyable.  That's because gpg has mangled it.  You
either need to turn it off or do detached signatures.

Thanks,

James



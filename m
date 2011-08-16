Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1HPRAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:00:04 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:53813 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab1HPRAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:00:02 -0400
MIME-Version: 1.0
In-Reply-To: <1313474539-5540-1-git-send-email-eric@purestorage.com>
References: <1313474539-5540-1-git-send-email-eric@purestorage.com>
Date: Tue, 16 Aug 2011 10:00:01 -0700
X-Google-Sender-Auth: rfhqTzysNJBtipZwPakKDxsF8ps
Message-ID: <CAA9_cmepi=F==qxGn9VPjXtpgmks8c1X29JercwpRCBsBYU79g@mail.gmail.com>
Subject: Re: [PATCH 1/2] block: Fix queue_flag update when rq_affinity goes
 from 2 to 1
From: Dan Williams <dan.j.williams@intel.com>
To: Eric Seppanen <eric@purestorage.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roland Dreier <roland@purestorage.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Jiang <dave.jiang@intel.com>, Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 11:02 PM, Eric Seppanen <eric@purestorage.com> wrote:
> From: Eric Seppanen <eric@purestorage.com>
>
> Commit 5757a6d76cdf added the QUEUE_FLAG_SAME_FORCE flag, but fails to
> clear that flag when the current state is '2' (SAME_COMP + SAME_FORCE)
> and the new state is '1' (SAME_COMP).
>
> Cc: Dan Williams <dan.j.williams@intel.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>

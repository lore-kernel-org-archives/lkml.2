Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab0EMKu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:50:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:60659 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758588Ab0EMKu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:50:27 -0400
X-User-Agent: K-9 Mail for Android
In-Reply-To: <20100512225629.GB5695@bicker>
References: <20100512225629.GB5695@bicker>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [patch] libsas: dereferencing variable before check
From: Tejun Heo <tj@kernel.org>
Date: Thu, 13 May 2010 01:08:05 +0200
To: Dan Carpenter <error27@gmail.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <23e0bf65-8758-45b3-b0a8-1df97db07d9a@email.android.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 10:50:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



"Dan Carpenter" <error27@gmail.com> wrote:

>The "qc->scsicmd" could be null so I moved the dereference inside the
>check.  This was introduced by 70b25f890: "[SCSI] fix locking around
>blk_abort_request()" 
>
>Signed-off-by: Dan Carpenter <error27@gmail.com>

Ooh.. right.

Asked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab0HaLx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:53:27 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:57899 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab0HaLxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:53:25 -0400
Date: Tue, 31 Aug 2010 13:53:14 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: lkml@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux390@de.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christoph Hellwig <hch@lst.de>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] wire up sys_time_change_notify() on s390
Message-ID: <20100831135314.253d6544@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1283255151-6364-7-git-send-email-virtuoso@slind.org>
References: <1283255151-6364-1-git-send-email-virtuoso@slind.org>
	<1283255151-6364-7-git-send-email-virtuoso@slind.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010 14:45:51 +0300
Alexander Shishkin <virtuoso@slind.org> wrote:

> Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
> CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
> CC: Heiko Carstens <heiko.carstens@de.ibm.com>
> CC: linux390@de.ibm.com
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Jesper Nilsson <jesper.nilsson@axis.com>
> CC: David Howells <dhowells@redhat.com>
> CC: Christian Borntraeger <borntraeger@de.ibm.com>
> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: linux-s390@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> ---
>  arch/s390/include/asm/unistd.h    |    3 ++-
>  arch/s390/kernel/compat_wrapper.S |    6 ++++++
>  arch/s390/kernel/syscalls.S       |    1 +
>  3 files changed, 9 insertions(+), 1 deletions(-)

System-call wiring for s390 looks good.
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


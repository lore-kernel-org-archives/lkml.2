Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab2FLPiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:38:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39045 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2FLPiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:38:15 -0400
Message-ID: <4FD76260.3020807@redhat.com>
Date: Tue, 12 Jun 2012 17:38:08 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        hughd@google.com
Subject: Re: [PATCH 0/2] msync improvements
References: <1338497035-13014-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1338497035-13014-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 31/05/2012 22:43, Paolo Bonzini ha scritto:
> These two patches are improvements on the implementation of the msync
> system call.  To give some context, I found them while working on
> the implementation of a persistent dirty bitmap.
> 
> Paolo Bonzini (2):
>   msync: support syncing a small part of the file
>   msync: start async writeout when MS_ASYNC
> 
>  include/linux/fs.h |    3 +-
>  mm/fadvise.c       |    2 +-
>  mm/filemap.c       |   11 +++++---
>  mm/msync.c         |   63 +++++++++++++++++++++++++++++++++-------------------
>  4 files changed, 50 insertions(+), 29 deletions(-)
> 

Ping?

Paolo

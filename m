Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1HCTYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:24:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380Ab1HCTYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:24:40 -0400
Date: Wed, 3 Aug 2011 21:21:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Richard Weinberger <richard@nod.at>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shm: optimize exit_shm()
Message-ID: <20110803192138.GB31267@redhat.com>
References: <20110803140456.GA14393@redhat.com> <20110803182417.GA2510@albatros> <20110803182826.GB2865@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803182826.GB2865@albatros>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Vasiliy Kulikov wrote:
>
> As .in_use may be changed to zero while current
> process was sleeping in down_write(),

Yes,

> we should check .in_use once again after
> down_write().

Why?

It doesn't hurt to recheck and I think the patch is correct.
But the changelog looks confusing.

Oleg.


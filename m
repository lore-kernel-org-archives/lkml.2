Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab0CaXz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:55:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab0CaXz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:55:58 -0400
Date: Thu, 1 Apr 2010 01:53:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Christoph Hellwig <hch@lst.de>,
       Janak Desai <janak@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] sys_unshare: simplify the not-really-implemented
	CLONE_THREAD/SIGHAND/VM code
Message-ID: <20100331235353.GA7565@redhat.com>
References: <20100323170816.GA20809@redhat.com> <m1hbo6u4xs.fsf@fess.ebiederm.org> <20100323230526.GA9932@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323230526.GA9932@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, Oleg Nesterov wrote:
>
> That said, I do not really care about this cleanup. I did it just because
> I sent another patch which touches check_unshare_flags(), and I was really
> surprised that ~70 lines in kernel/fork.c do nothing but confuse the reader.

I changed my mind. I do care ;)

Seriously, Eric, it is just stupid this code does nothing but complicates
fork.c, and unless you prove this patch is wrong you can't convince me
this patch is bad idea.

> Please nack this patch and lets forget it ;)

Yes. You have all rights to nack it and I won't insist even if I disagree.
But please do this explicitly, otherwise I'll resend it.

Oleg.


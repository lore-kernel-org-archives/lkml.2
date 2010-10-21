Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab0JUSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 14:16:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab0JUSQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 14:16:56 -0400
Date: Thu, 21 Oct 2010 20:12:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Brian Behlendorf <behlendorf1@llnl.gov>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make div64_u64() precise on 32bit platforms
Message-ID: <20101021181220.GA8827@redhat.com>
References: <201010121227.05735.behlendorf1@llnl.gov> <20101013213746.GA27248@redhat.com> <20101014121159.GA407@redhat.com> <1287683202.16680.44.camel@pip>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287683202.16680.44.camel@pip>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please drop

	lib-div64c-document-that-div64_u64-is-not-precise-on-32bit-platforms.patch

On 10/21, Brian Behlendorf wrote:
>
> I think we should use your simpler version.  There's no good reason to
> make this more complicated than it needs to be.  I haven't been able to
> find a test case where your changes get the wrong result.

Great!

> From: Brian Behlendorf <behlendorf1@llnl.gov>
> Date: Thu, 5 Aug 2010 14:59:11 -0700
> Subject: [PATCH] Fix div64_u64 for 32bit platforms
>
> The current implementation of div64_u64 for 32bit systems returns
> an approximately correct result when the divisor exceeds 32bits.
> Since doing 64bit division using 32bit hardware is a long since
> solved problem we just use one of the existing proven methods.

Brian, you forgot to add your sob. Hopefully Andrew can add

	Signed-off-by: Brian Behlendorf <behlendorf1@llnl.gov>

Signed-off-by: Oleg Nesterov <oleg@redhat.com>


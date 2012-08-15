Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab2HONnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:43:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab2HONnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:43:15 -0400
Subject: Re: [PATCH] select GENERIC_ATOMIC64 for c6x/score/unicore32 archs
From: Mark Salter <msalter@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Aurelien Jacquiot <a-jacquiot@ti.com>,
        linux-c6x-dev@linux-c6x.org, Lennox Wu <lennox.wu@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Date: Wed, 15 Aug 2012 09:42:58 -0400
In-Reply-To: <20120815023608.GA24697@localhost>
References: <20120814153413.GA18601@localhost>
	 <1344961371.30830.43.camel@deneb.redhat.com>
	 <20120815023608.GA24697@localhost>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1345038181.2750.20.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 10:36 +0800, Fengguang Wu wrote:
> > -#define L1_CACHE_BYTES        L2_CACHE_BYTES
> > +#define L1_CACHE_SHIFT        L2_CACHE_SHIFT
> > +#define L1_CACHE_BYTES        (1 << L2_CACHE_SHIFT)
> 
> Nitpick: the last line could better be:
> 
> +#define L1_CACHE_BYTES        (1 << L1_CACHE_SHIFT)
> 
> Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

Yes, I noticed that after sending the patch.

Should I push this through the c6x tree?

--Mark



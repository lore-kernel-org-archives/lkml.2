Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab2FZLuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 07:50:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab2FZLuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 07:50:10 -0400
Message-ID: <1340711393.12269.15.camel@cr0>
Subject: Re: [PATCH 00/12] kmap_atomic cleanup for 3.6
From: Cong Wang <amwang@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        dhowells <dhowells@redhat.com>
Date: Tue, 26 Jun 2012 19:49:53 +0800
In-Reply-To: <1340698655.21991.24.camel@twins>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
	 <201206251518.08791.arnd@arndb.de> <1340645735.18025.88.camel@twins>
	 <201206252043.53231.arnd@arndb.de> <1340698655.21991.24.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 10:17 +0200, Peter Zijlstra wrote:
> On Mon, 2012-06-25 at 20:43 +0000, Arnd Bergmann wrote:
> > How about putting that constant into asm/highmem.h then, and adding a
> > default like
> > 
> > #ifndef KM_TYPE_NR
> > #define KM_TYPE_NR 8
> > #endif
> > 
> > in linux/highmem.h? Then FRV and anything else that needs it can override
> > the value and the other ones don't need to bother.
> 
> At least put in a hand-wavy argument supporting whatever one number
> that's being put in. That way a reader at least as some incling as to
> where it comes from and what needs checking if it turns out its wrong.

Ok, I will do it in a separated patch.

Thanks!


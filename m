Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2FYE0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 00:26:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab2FYE0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 00:26:35 -0400
Message-ID: <1340598382.19173.3.camel@cr0>
Subject: Re: [PATCH 00/12] kmap_atomic cleanup for 3.6
From: Cong Wang <amwang@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 25 Jun 2012 12:26:22 +0800
In-Reply-To: <201206232111.25411.arnd@arndb.de>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
	 <201206232111.25411.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-23 at 21:11 +0000, Arnd Bergmann wrote:
> On Saturday 23 June 2012, Cong Wang wrote:
> > After few releases, it seems there are no more callers
> > using the deprecated form of kmap_atomic(), the one
> > with two parameters. So we can remove it now and remove
> > the KM_* definition except KM_TYPE_NR together.
> > 
> > All the patches are available at:
> > 
> >         git://github.com/congwang/linux.git #kmap_atomic
> > 
> 
> What is the significance of having an architecture-specific
> definition for KM_TYPE_NR now? Should that be replaced
> with a fixed value in include/linux/highmem.h so we can
> remove the asm/kmap_types.h files entirely?
> 

Different arch has different values for KM_TYPE_NR, I am not sure if
unifying them to a fixed value could fit all? For safety, I kept their
original values.

Thanks.


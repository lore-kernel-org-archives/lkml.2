Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2C1HYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:24:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60843 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab2C1HYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:24:46 -0400
Date: Wed, 28 Mar 2012 00:24:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hillf Danton <dhillf@gmail.com>
cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hugetlbfs: add err code in initializing module
In-Reply-To: <CAJd=RBC=ajApxw_+tfOoY9KpTNW2Y+_B5MxDOjBH3Y5-PDW2jg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1203280023040.16201@chino.kir.corp.google.com>
References: <CAJd=RBBK4tx91ZQu0WKzBGx8E-Na6oUwmpBUQVB0yPkR=ySPjg@mail.gmail.com> <20120322003356.GT6589@ZenIV.linux.org.uk> <CAJd=RBC=ajApxw_+tfOoY9KpTNW2Y+_B5MxDOjBH3Y5-PDW2jg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2012, Hillf Danton wrote:

> Due to bad idea and bad example, please issue Nack, then the patch
> that was not well prepared will be dropped.
> 

The patch is still in linux-next as of yesterday's tree, so please propose 
a follow-up patch that removes the unregister_filesystem() since the 
setting of "error" when kmem_cache_create() is still correct.

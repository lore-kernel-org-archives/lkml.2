Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab2EKUjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 16:39:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab2EKUjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 16:39:41 -0400
Date: Fri, 11 May 2012 13:39:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memory: add kernelcore_max_addr boot option
Message-Id: <20120511133939.25b5a738.akpm@linux-foundation.org>
In-Reply-To: <4FACA79C.9070103@cn.fujitsu.com>
References: <4FACA79C.9070103@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 13:46:04 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Current ZONE_MOVABLE (kernelcore=) setting policy with boot option doesn't meet
> our requirement. We need something like kernelcore_max_addr= boot option
> to limit the kernelcore upper address.

Why do you need this?  Please fully describe the requirement/use case.

> The memory with higher address will be migratable(movable) and they
> are easier to be offline(always ready to be offline when the system don't require
> so much memory).
> 
> All kernelcore_max_addr=, kernelcore= and movablecore= can be safely specified
> at the same time(or any 2 of them).

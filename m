Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab1HYL7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 07:59:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34978 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab1HYL7F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 07:59:05 -0400
Subject: Re: [PATCH v2] lockdep: Add helper function for dir vs file i_mutex
 annotation
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, davej@redhat.com,
        linux-kernel@vger.kernel.org
Date: Thu, 25 Aug 2011 13:58:48 +0200
In-Reply-To: <20110825114811.GO2270@zod.bos.redhat.com>
References: <20110825114811.GO2270@zod.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314273528.27911.7.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 07:48 -0400, Josh Boyer wrote:
> This moves the directory vs file lockdep annotation into a helper function
> that can be called by in-memory filesystems and has hugetlbfs call it.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com> 

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

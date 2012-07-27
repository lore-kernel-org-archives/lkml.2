Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2G0Tne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:43:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:56376 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab2G0Tnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:43:33 -0400
Message-ID: <1343418204.32120.40.camel@twins>
Subject: Re: [PATCH 5/6] rbtree: faster augmented erase
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Jul 2012 21:43:24 +0200
In-Reply-To: <1342787467-5493-6-git-send-email-walken@google.com>
References: <1342787467-5493-1-git-send-email-walken@google.com>
	 <1342787467-5493-6-git-send-email-walken@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 05:31 -0700, Michel Lespinasse wrote:
> --- a/lib/rbtree_test.c
> +++ b/lib/rbtree_test.c
> @@ -1,5 +1,6 @@
>  #include <linux/module.h>
>  #include <linux/rbtree.h>
> +#include <linux/rbtree_internal.h> 

This confuses me.. either its internal to the rb-tree implementation and
users don't need to see it, or its not in which case huh?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab2GIWXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:23:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41946 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab2GIWXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:23:19 -0400
Date: Mon, 9 Jul 2012 15:23:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: linux-kernel@vger.kernel.org
cc: mm-commits@vger.kernel.org, joe@perches.com, apw@canonical.com
Subject: Re: + checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch
 added to -mm tree
In-Reply-To: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com>
Message-ID: <alpine.DEB.2.00.1207091514310.32082@chino.kir.corp.google.com>
References: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, akpm@linux-foundation.org wrote:

> From: Joe Perches <joe@perches.com>
> Subject: checkpatch: Add acheck for use of sizeof without parenthesis
> 
> Kernel style uses parenthesis around sizeof.
> 

Nack, there's a difference between "sizeof *task" and 
"sizeof(struct task_struct)".  The former operates on a unary expression 
and the latter operates on a type.  There are over 1000 occurrences in the 
kernel where the sizeof operator, the former, is used on a unary 
expression.

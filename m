Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2GGIka (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 04:40:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45513 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab2GGIk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 04:40:26 -0400
Date: Sat, 7 Jul 2012 01:40:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <js1304@gmail.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: don't invoke __alloc_pages_direct_compact when order
 0
In-Reply-To: <1341588521-17744-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1207070139510.10445@chino.kir.corp.google.com>
References: <1341588521-17744-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jul 2012, Joonsoo Kim wrote:

> __alloc_pages_direct_compact has many arguments so invoking it is very costly.
> And in almost invoking case, order is 0, so return immediately.
> 

If "zero cost" is "very costly", then this might make sense.

__alloc_pages_direct_compact() is inlined by gcc.

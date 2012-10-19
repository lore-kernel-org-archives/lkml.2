Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab2JSOKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:10:10 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:50574 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758559Ab2JSOKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:10:08 -0400
Date: Fri, 19 Oct 2012 14:10:07 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ezequiel Garcia <elezegarcia@gmail.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tim Bird <tim.bird@am.sony.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/3] mm/slob: Use object_size field in
 kmem_cache_size()
In-Reply-To: <1350649992-25988-2-git-send-email-elezegarcia@gmail.com>
Message-ID: <0000013a795c0df5-32399699-2e0d-4ecf-a902-be4c6da61c98-000000@email.amazonses.com>
References: <1350649992-25988-1-git-send-email-elezegarcia@gmail.com> <1350649992-25988-2-git-send-email-elezegarcia@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012, Ezequiel Garcia wrote:

> Fields object_size and size are not the same: the latter might include
> slab metadata. Return object_size field in kmem_cache_size().
> Also, improve trace accuracy by correctly tracing reported size.

Acked-by: Christoph Lameter <cl@linux.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab2JVMHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:07:54 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39375 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab2JVMHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:07:53 -0400
Message-ID: <5085370F.80204@parallels.com>
Date: Mon, 22 Oct 2012 16:07:43 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/2] mm/slob: Use free_page instead of put_page for page-size
 kmalloc allocations
References: <1350907471-2236-1-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1350907471-2236-1-git-send-email-elezegarcia@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 04:04 PM, Ezequiel Garcia wrote:
> When freeing objects, the slob allocator currently free empty pages
> calling __free_pages(). However, page-size kmallocs are disposed
> using put_page() instead.
> 
> It makes no sense to call put_page() for kernel pages that are provided
> by the object allocator, so we shouldn't be doing this ourselves.
> 
> This is based on:
> commit d9b7f22623b5fa9cc189581dcdfb2ac605933bf4
> Author: Glauber Costa <glommer@parallels.com>
Acked-by: Glauber Costa <glommer@parallels.com>


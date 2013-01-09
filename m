Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934010Ab3AIU5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:57:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933735Ab3AIU5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:57:17 -0500
Message-ID: <50EDD9A5.8060404@redhat.com>
Date: Wed, 09 Jan 2013 15:57:09 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Matt Turner <mattst88@gmail.com>, David Howells <dhowells@redhat.com>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: Re: [PATCH 6/8] mm: remove free_area_cache use in powerpc architecture
References: <1357694895-520-1-git-send-email-walken@google.com> <1357694895-520-7-git-send-email-walken@google.com>
In-Reply-To: <1357694895-520-7-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 08:28 PM, Michel Lespinasse wrote:
> As all other architectures have been converted to use vm_unmapped_area(),
> we are about to retire the free_area_cache.
>
> This change simply removes the use of that cache in
> slice_get_unmapped_area(), which will most certainly have a
> performance cost. Next one will convert that function to use the
> vm_unmapped_area() infrastructure and regain the performance.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>


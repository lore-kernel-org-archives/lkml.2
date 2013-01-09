Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab3AISdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 13:33:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758021Ab3AISdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 13:33:07 -0500
Message-ID: <50EDB7D9.8000403@redhat.com>
Date: Wed, 09 Jan 2013 13:32:57 -0500
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
Subject: Re: [PATCH 5/8] mm: use vm_unmapped_area() in hugetlbfs on ia64 architecture
References: <1357694895-520-1-git-send-email-walken@google.com> <1357694895-520-6-git-send-email-walken@google.com>
In-Reply-To: <1357694895-520-6-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 08:28 PM, Michel Lespinasse wrote:
> Update the ia64 hugetlb_get_unmapped_area function to make use of
> vm_unmapped_area() instead of implementing a brute force search.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>


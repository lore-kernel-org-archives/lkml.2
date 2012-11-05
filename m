Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab2KEXcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:32:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab2KEXcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:32:43 -0500
Message-ID: <50984D24.9070409@redhat.com>
Date: Mon, 05 Nov 2012 18:35:00 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, x86@kernel.org,
        William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 12/16] mm: use vm_unmapped_area() on sh architecture
References: <1352155633-8648-1-git-send-email-walken@google.com> <1352155633-8648-13-git-send-email-walken@google.com>
In-Reply-To: <1352155633-8648-13-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 05:47 PM, Michel Lespinasse wrote:
> Update the sh arch_get_unmapped_area[_topdown] functions to make
> use of vm_unmapped_area() instead of implementing a brute force search.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Reviewed-by: Rik van Riel <riel@redhat.com>


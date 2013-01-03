Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab3ACFtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 00:49:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab3ACFtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 00:49:23 -0500
Message-ID: <50E51BDA.8020102@redhat.com>
Date: Thu, 03 Jan 2013 00:49:14 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Jorn_Engel <joern@logfs.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] mm: remove flags argument to mmap_region
References: <1356050997-2688-1-git-send-email-walken@google.com> <1356050997-2688-8-git-send-email-walken@google.com>
In-Reply-To: <1356050997-2688-8-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 07:49 PM, Michel Lespinasse wrote:
> After the MAP_POPULATE handling has been moved to mmap_region() call sites,
> the only remaining use of the flags argument is to pass the MAP_NORESERVE
> flag. This can be just as easily handled by do_mmap_pgoff(), so do that
> and remove the mmap_region() flags parameter.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed

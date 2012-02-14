Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829Ab2BNJnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:43:41 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34694 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600Ab2BNJnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:43:37 -0500
MIME-Version: 1.0
In-Reply-To: <20120214005301.a9d5be1a.akpm@linux-foundation.org>
References: <1329204499-2671-1-git-send-email-hamo.by@gmail.com> <20120214005301.a9d5be1a.akpm@linux-foundation.org>
From: Yang Bai <hamo.by@gmail.com>
Date: Tue, 14 Feb 2012 17:43:17 +0800
Message-ID: <CAO_0yfOjstSnhqf_DBBr7-it48GyUObF2=4GeMd7TDo_TPaLPg@mail.gmail.com>
Subject: Re: [PATCH] slab: warning if total alloc size overflow
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 4:53 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 14 Feb 2012 15:28:19 +0800 Yang Bai <hamo.by@gmail.com> wrote:
>
>
> One of the applications of kcalloc() is to prevent userspace from
> causing a multiplicative overflow (and then perhaps causing an
> overwrite beyond the end of the allocated memory).
>
> With this patch, we've just handed the user a way of spamming the logs
> at 1MHz.  This is bad.
>
>
> Also, please let's not randomly add debug stuff in places where we've
> never demonstrated a need for it.

Ok. Please just drop this patch.

Thanks.

-- 
    """
    Keep It Simple,Stupid.
    """

Chinese Name: 白杨
Nick Name: Hamo
Homepage: http://hamobai.com/
GPG KEY ID: 0xA4691A33
Key fingerprint = 09D5 2D78 8E2B 0995 CF8E  4331 33C4 3D24 A469 1A33

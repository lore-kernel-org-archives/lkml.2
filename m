Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab2JaG4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:56:46 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:44231 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab2JaG4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:56:43 -0400
MIME-Version: 1.0
In-Reply-To: <1350600107-4558-1-git-send-email-elezegarcia@gmail.com>
References: <1350600107-4558-1-git-send-email-elezegarcia@gmail.com>
Date: Wed, 31 Oct 2012 08:56:42 +0200
X-Google-Sender-Auth: D3QaxN42aPL3z5ryf_-SWaps5Sc
Message-ID: <CAOJsxLHxgeYEmfoLrzaTNGj88xOhteBKFJKVzPqzrte-B18nSg@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/slob: Drop usage of page->private for storing
 page-sized allocations
From: Pekka Enberg <penberg@kernel.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 1:41 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> This field was being used to store size allocation so it could be
> retrieved by ksize(). However, it is a bad practice to not mark a page
> as a slab page and then use fields for special purposes.
> There is no need to store the allocated size and
> ksize() can simply return PAGE_SIZE << compound_order(page).
>
> Cc: Pekka Penberg <penberg@kernel.org>
> Acked-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>

Applied all three patches. Thanks, Ezequiel!

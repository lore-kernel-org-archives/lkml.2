Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934373Ab2FHUQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 16:16:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33022 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758916Ab2FHUQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 16:16:40 -0400
MIME-Version: 1.0
In-Reply-To: <1339182919-11432-3-git-send-email-levinsasha928@gmail.com>
References: <1339182919-11432-1-git-send-email-levinsasha928@gmail.com>
	<1339182919-11432-3-git-send-email-levinsasha928@gmail.com>
Date: Fri, 8 Jun 2012 23:16:39 +0300
X-Google-Sender-Auth: rGOoi_fprs9fA-LZ2MYpXk9-VMs
Message-ID: <CAOJsxLG2H_G3CrmqNSxEnYRB+mACRyeG4dOQZ6wasXV1V0vGYg@mail.gmail.com>
Subject: Re: [PATCH v2 02/10] mm: frontswap: trivial coding convention issues
From: Pekka Enberg <penberg@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: dan.magenheimer@oracle.com, konrad.wilk@oracle.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 10:15 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  mm/frontswap.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/frontswap.c b/mm/frontswap.c
> index 557e8af4..b619d29 100644
> --- a/mm/frontswap.c
> +++ b/mm/frontswap.c
> @@ -150,6 +150,7 @@ int __frontswap_store(struct page *page)
>                inc_frontswap_failed_stores();
>        } else
>                inc_frontswap_failed_stores();
> +       }

This looks wrong. Did you compile it?

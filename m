Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750890Ab1BJFHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 00:07:45 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52453 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1BJFHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 00:07:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=f/7//rc2CIKDN4Gs6lMDW0zE97Lj1ac5y9gE8JOnkw0cN8cs64y+93J8IkeRhvMNTe
         g0zJurBOK5pkU32kDjed2IsidCAsNQ3/e3uApn/23z5dDmuRNcvxuiLVDKil0G3nC+1u
         T3/K8FZdWLqfHFgaRczbcLYqHlXY3+kHBi1uQ=
MIME-Version: 1.0
In-Reply-To: <1297313788-10905-1-git-send-email-ozaki.ryota@gmail.com>
References: <1297313788-10905-1-git-send-email-ozaki.ryota@gmail.com>
Date: Thu, 10 Feb 2011 14:07:43 +0900
Message-ID: <AANLkTikFEjeVJ2HY_KTv29y63bt_+8SwWm7K3Ywdw570@mail.gmail.com>
Subject: Re: [PATCH v2] mm: Fix out-of-date comments which refers non-existent functions
From: Minchan Kim <minchan.kim@gmail.com>
To: Ryota Ozaki <ozaki.ryota@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 1:56 PM, Ryota Ozaki <ozaki.ryota@gmail.com> wrote:
> From: Ryota Ozaki <ozaki.ryota@gmail.com>
>
> do_file_page and do_no_page don't exist anymore, but some comments
> still refers them. The patch fixes them by replacing them with
> existing ones.
>
> Signed-off-by: Ryota Ozaki <ozaki.ryota@gmail.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Jiri Kosina <trivial@kernel.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Thanks.
-- 
Kind regards,
Minchan Kim

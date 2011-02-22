Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1BVMVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 07:21:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42502 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab1BVMVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 07:21:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RtV/D0FG2Be5v3twU97YayJRFbHp/j+n4Do798nDXNnpeFVYjG2Aju/qpDX3cxVgn5
         dKkg4eUf2PA6XJ845SmnPBRMkqPSSEzYC/juCGxT3vD9KhC2Uh+5fcN5yKr+zAfeT7R4
         JVCMIJXKw/v6r5qtONDn8DUwVsEZVVHbx5pSA=
MIME-Version: 1.0
In-Reply-To: <1298371877-2906-1-git-send-email-namhyung@gmail.com>
References: <1298371877-2906-1-git-send-email-namhyung@gmail.com>
Date: Tue, 22 Feb 2011 21:21:19 +0900
Message-ID: <AANLkTin2trwC1BUNq8=bOSq+GfB2Bye44GMK9OS3DFUz@mail.gmail.com>
Subject: Re: [PATCH] mempolicy: remove redundant check in __mpol_equal()
From: Minchan Kim <minchan.kim@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Bob Liu <lliubbo@gmail.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 7:51 PM, Namhyung Kim <namhyung@gmail.com> wrote:
> The 'flags' field is already checked, no need to do it again.
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Bob Liu <lliubbo@gmail.com>
> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Bob's mempolicy: remove redundant check(1980050250) made it redundant.
Good eye!


-- 
Kind regards,
Minchan Kim

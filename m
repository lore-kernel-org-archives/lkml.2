Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021Ab0DFEPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 00:15:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57572 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab0DFEPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 00:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SA1vXkiGmbzX/LmbN4K4ZCf9xOidp1neG799Q5oLYqbV8LeS4glb1dGzxdfGeAhNWH
         mZssNfL/DnZih+qkxNttzKahTUQrb31f1VCkPqI027RbZstjMUpZC1zmUmxgvk0hIuqi
         qV2/pWY4z8CJRbbi1NLWWnRzDrvnkUzsV2vHg=
MIME-Version: 1.0
In-Reply-To: <1270523356-1728-1-git-send-email-arve@android.com>
References: <20100405101424.GA21207@csn.ul.ie>
	 <1270523356-1728-1-git-send-email-arve@android.com>
Date: Tue, 6 Apr 2010 13:15:12 +0900
Message-ID: <k2g28c262361004052115ie21bd036hcbdbdb7750f2942b@mail.gmail.com>
Subject: Re: [PATCH] mm: Check if any page in a pageblock is reserved before 
	marking it MIGRATE_RESERVE
From: Minchan Kim <minchan.kim@gmail.com>
To: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       TAO HU <tghk48@motorola.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "Ye Yuan.Bo-A22116" <yuan-bo.ye@motorola.com>,
       Chang Qing-A21550 <Qing.Chang@motorola.com>,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 6, 2010 at 12:09 PM, Arve Hjønnevåg <arve@android.com> wrote:
> This fixes a problem where the first pageblock got marked MIGRATE_RESERVE even
> though it only had a few free pages. This in turn caused no contiguous memory
> to be reserved and frequent kswapd wakeups that emptied the caches to get more
> contiguous memory.

It would be better to add following your description of previous mail thread.
It can help others understand it in future.

On Fri, Apr 02, 2010 at 05:59:00PM -0700, Arve Hj?nnev?g wrote:
...
"I think this happens by default on arm. The kernel starts at offset
0x8000 to leave room for boot parameters, and in recent kernel
versions (>~2.6.26-29) this memory is freed."


-- 
Kind regards,
Minchan Kim

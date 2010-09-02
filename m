Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0IBPeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:34:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48547 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab0IBPeG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:34:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N4GLisx2Y1tz3N7oAF6DFBjGGvmJTFP9CSVosnLWN95dged+WuMIzT+HT+F31USInS
         Cbs0rLzA9uWLWIN1LiOZQwfx71MUG5x1vwodSXZ9U6JVydRWcyq5YqLevVaIzsH9Gyer
         kakQ47qu3LjzznQH+eoJL+r0tmW4LSejFI86g=
MIME-Version: 1.0
In-Reply-To: <4C7FBFE6.7060600@redhat.com>
References: <1283440333-14451-1-git-send-email-minchan.kim@gmail.com>
	<4C7FBFE6.7060600@redhat.com>
Date: Fri, 3 Sep 2010 00:34:03 +0900
Message-ID: <AANLkTikWok_3ANHuxVs=muTVKi3AbcQTphxAfBT613u2@mail.gmail.com>
Subject: Re: [PATCH v2] vmscan: prevent background aging of anon page in no
 swap system
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ying Han <yinghan@google.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will fix.
Thanks for the quick response. Rik.

On Fri, Sep 3, 2010 at 12:16 AM, Rik van Riel <riel@redhat.com> wrote:
> On 09/02/2010 11:12 AM, Minchan Kim wrote:
>
>> +       /*
>> +        * If we don't have enough swap space, anonymous page deactivation
>> +        * is pointless.
>> +        */
>> +       if (!nr_swap_pages)
>> +               return 0;
>
> It may be better to test !total_swap_pages and change the
> comment to:
>
>        /*
>         * If we don't have swap space, anonymous page deactivation
>         * is pointless.
>         */
>
> --
> All rights reversed
>



-- 
Kind regards,
Minchan Kim

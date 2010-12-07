Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab0LGARW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 19:17:22 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42074 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab0LGARV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 19:17:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YvTe2K1vTRuCaILjKF30zW+O4L6zLguimpuhfH2KDlgI1d812X8bBUjnriy5jO4w0P
         owMfUmLqRQnmqVhSWHP/0aepesO1D3OCOAEfZ9cnkw0CzmbTKmbxyIkG+nAnwMVloFeh
         H3EBy7fC4PMCOt4Pa5uKb8XBOIbQrwZr0+Ia0=
MIME-Version: 1.0
In-Reply-To: <4CFC52D7.8040003@redhat.com>
References: <cover.1291568905.git.minchan.kim@gmail.com>
	<a11d438e09af9808ac0cb0aba3e74c8a8deb4076.1291568905.git.minchan.kim@gmail.com>
	<4CFC52D7.8040003@redhat.com>
Date: Tue, 7 Dec 2010 09:17:21 +0900
Message-ID: <AANLkTi=KQxRyHnT+mqrGg3-XWrD_R=b3wuEVBzdsVwaV@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] move memcg reclaimable page into tail of inactive list
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 12:04 PM, Rik van Riel <riel@redhat.com> wrote:
> On 12/05/2010 12:29 PM, Minchan Kim wrote:
>>
>> Golbal page reclaim moves reclaimalbe pages into inactive list
>> to reclaim asap. This patch apply the rule in memcg.
>> It can help to prevent unnecessary working page eviction of memcg.
>
> The patch is right, but the description is wrong.
>
> The rotate_reclaimable_page function moves just written out
> pages, which the VM wanted to reclaim, to the end of the
> inactive list.  That way the VM will find those pages first
> next time it needs to free memory.

Will fix.

>
>> Cc: Balbir Singh<balbir@linux.vnet.ibm.com>
>> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>> Cc: Rik van Riel<riel@redhat.com>
>> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>
>
> Reviewed-by: Rik van Riel <riel@redhat.com>

Thanks, Rik.

>
> --
> All rights reversed
>



-- 
Kind regards,
Minchan Kim

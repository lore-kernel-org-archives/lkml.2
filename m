Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0IMArF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 20:47:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37810 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab0IMArD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 20:47:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vE8aHSVuRm30xEB++i3lDerUTkjwVoMFqiLAtMcDA9clzplEhcYvwt8PdLQz95aumu
         S1o3MnGL848ItVaSt0T8AN5dXrdbTtd9B9OMDU6xBHw9h9+VpBph0Nvs22Ryl0u48w2S
         9VMuSz5ji1lFZKYDtpd7IadElIA49TDq4Ywmc=
MIME-Version: 1.0
In-Reply-To: <201009121942.53543.rjw@sisk.pl>
References: <20100912163200.GA4098@barrios-desktop>
	<201009121942.53543.rjw@sisk.pl>
Date: Mon, 13 Sep 2010 09:47:02 +0900
Message-ID: <AANLkTimzby23QO4w0o1vSHnin9AakoG+cp9zd6a8T6FA@mail.gmail.com>
Subject: Re: [PATCH v2] vmscan: check all_unreclaimable in direct reclaim path
From: Minchan Kim <minchan.kim@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        "M. Vefa Bicakci" <bicave@superonline.com>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 2:42 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, September 12, 2010, Minchan Kim wrote:
>> Adnrew, Please drop my old version and merge this verstion.
>> (old : vmscan-check-all_unreclaimable-in-direct-reclaim-path.patch)
>>
>>  * Changelog from v2
>>    * remove inline - suggested by Andrew
>>    * add function desription - suggeseted by Adnrew
>>
>> == CUT HERE ==
>
> For the record, this commit:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6715045ddc7472a22be5e49d4047d2d89b391f45
>
> is reported to fix the problem without the $subject patch (see
> http://lkml.org/lkml/2010/9/11/129).  So, I'm not sure if it's still necessary
> to special case this particular situation?


I didn't follow your patch.
If your patch can fix the problem, We don't need new overhead direct
reclaim without big benefit. So I don't care of dropping this patch.

We need agreement of another author KOSAKI.

Thanks for the information, Rafael. :)
-- 
Kind regards,
Minchan Kim

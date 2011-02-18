Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab1BRDAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:00:37 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55559 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab1BRDAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:00:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nx8+4nFwiNowRbwSsoQV+K96hxHwmxJ6pciqFSGyE5mbKvLCWUybwINChJn1oYX4Pi
         oMR8Yx9Y4NzayvUQ7oCOaPGpknEA3F8bxJA60tBInwiWrrwrteSw5kRkDYDMrfuf9iYu
         tREO6VcZ5ywYx2+nnQckYL8Mb73Z2v37K+PQE=
Subject: Re: [PATCH] mm: fix dubious code in __count_immobile_pages()
From: Namhyung Kim <namhyung@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTi=vRekoBFgHu-AXiLwTVTYLX-FFMBoF0twg1Rpg@mail.gmail.com>
References: <1297993586-3514-1-git-send-email-namhyung@gmail.com>
	 <AANLkTi=vRekoBFgHu-AXiLwTVTYLX-FFMBoF0twg1Rpg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 12:00:28 +0900
Message-ID: <1297998028.1440.7.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-02-18 (금), 11:26 +0900, Minchan Kim:
> On Fri, Feb 18, 2011 at 10:46 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> > When pfn_valid_within() failed 'iter' was incremented twice.
> >
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> 
> Nitpick.
> 
> I am not sure it's best. I don't like below trick.
> iter += (1 << page_order(page)) - 1;
> 
> So we can change for loop with while as removing -1 trick of PageBuddy.
> But if you don't like it, I don't mind it. :)
> 
> Thanks!
> 

Hi Minchan,

Either is fine to me. But I think current code would be shorter.


-- 
Regards,
Namhyung Kim



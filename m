Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1CVKHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:07:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39126 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab1CVKHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=N5adKt0RR8k0kXlr0TizhKgFLHfrPolDW7m8qrZxjrsJDikinYyLGuY5/TzUVqzkpg
         X8T5T700t3zQzs/y3mw8uLcdjT/SzIXoh2QZ90a/K4k/4Kkh6QpRSzK0s9evtykWhjRU
         t5KnoXWmru4Yu3+sWnDqCbxnVRTfvXT4msaOw=
Subject: Re: [PATCH 3/3] memcg: move page-freeing code outside of lock
From: Namhyung Kim <namhyung@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110322135619.90593f5d.kamezawa.hiroyu@jp.fujitsu.com>
References: <1300452855-10194-1-git-send-email-namhyung@gmail.com>
	 <1300452855-10194-3-git-send-email-namhyung@gmail.com>
	 <20110322085938.0691f7f4.kamezawa.hiroyu@jp.fujitsu.com>
	 <1300763079.1483.21.camel@leonhard>
	 <20110322135619.90593f5d.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 19:06:57 +0900
Message-ID: <1300788417.1492.2.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-03-22 (화), 13:56 +0900, KAMEZAWA Hiroyuki:
> On Tue, 22 Mar 2011 12:04:39 +0900
> Namhyung Kim <namhyung@gmail.com> wrote:
> 
> > 2011-03-22 (화), 08:59 +0900, KAMEZAWA Hiroyuki:
> > > On Fri, 18 Mar 2011 21:54:15 +0900
> > > Namhyung Kim <namhyung@gmail.com> wrote:
> > > 
> > > > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > > > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > 
> > > What is the benefit of this patch ?
> > > 
> > > -Kame
> > > 
> > 
> > Oh, I just thought generally it'd better call such a (potentially)
> > costly function outside of locks and it could reduce few of theoretical
> > contentions between swapons and/or offs. If it doesn't help any
> > realistic cases I don't mind discarding it.
> > 
> 
> My point is, please write patch description which shows for what this patc is.
> All cleanup are okay to me if it reasonable. But without patch description as
> "this is just a cleanup, no functional change, and the reason is...."
> we cannot maintain patches.
> 
> Thanks,
> -Kame
> 

OK, I will do that in the future. Anyway, do you want me to resend the
patch with new description?

Thanks.


-- 
Regards,
Namhyung Kim



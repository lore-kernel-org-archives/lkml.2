Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab1EWChD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 22:37:03 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45417 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab1EWChB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 22:37:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RobeZ+f49MYrALMoqOHrkCtIl1SzC30F2majathrDnGyKiSLU75MH0vhKnsqSQzMgy
         A/m9F4yNNerLSVJmKYag2+YCo9x/+2E0kOezTFNROfDvl7a1hzffadastWi5GKCZTaR/
         nplQgyG4WVNgKGoiBMEdHVbICsUHL6lvfMTUI=
MIME-Version: 1.0
In-Reply-To: <4DD62007.6020600@jp.fujitsu.com>
References: <4DD61F80.1020505@jp.fujitsu.com>
	<4DD62007.6020600@jp.fujitsu.com>
Date: Mon, 23 May 2011 11:37:00 +0900
Message-ID: <BANLkTineOmdV9wjK-5CmR9YTbMXyR8L7og@mail.gmail.com>
Subject: Re: [PATCH 2/5] oom: kill younger process first
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/20 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
> This patch introduces do_each_thread_reverse() and select_bad_process()
> uses it. The benefits are two, 1) oom-killer can kill younger process
> than older if they have a same oom score. Usually younger process is
> less important. 2) younger task often have PF_EXITING because shell
> script makes a lot of short lived processes. Reverse order search can
> detect it faster.
>
> Reported-by: CAI Qian <caiqian@redhat.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim

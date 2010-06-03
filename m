Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab0FCGUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:20:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55070 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab0FCGUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:20:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sXMBlOZ3cH+re5nF052bkRVGM3m/NZ41lxogE94iEIIc7G5HWvretQq6thpfLCXKuu
         PIHvqJnVcn8qi15QfLS4azogqQzbwfneHZZY1taJ6wtwXw2FZRinktdMjlf+RY+R+7Dj
         pPjZdEXeVHAnM1+KqGqbV5reHvDHUIfTP83uQ=
MIME-Version: 1.0
In-Reply-To: <20100603145036.7250.A69D9226@jp.fujitsu.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com>
	<20100603145036.7250.A69D9226@jp.fujitsu.com>
Date: Thu, 3 Jun 2010 15:20:00 +0900
Message-ID: <AANLkTimjtfADsrmTLo5wwBMHN3UDRc5ya0gflB3L63vq@mail.gmail.com>
Subject: Re: [PATCH 03/12] oom: the points calculation of child processes must 
	use find_lock_task_mm() too
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 2:51 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> child point calclation use find_lock_task_mm() too.

Sorry but I have to hurt you, again.
Although we guess what you want, For future, please, write down
description more clearly.

>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim

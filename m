Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab0FCGLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:11:45 -0400
Received: from mail-yw0-f179.google.com ([209.85.211.179]:44844 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651Ab0FCGLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:11:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jnYPzg/5zW6M2da+pDt/E5qul2Ig8HC6QHHRkav27P2h6zcI9W1arBiWSurCTiNj3V
         UCiuOtE+SenP0iFLORaJJqoyzpGeTroRXoIPnMSgrS9177+4LhMoVIZonAz3/rwyuc/Q
         AZnsxcZNUnzOI9w/s551LD4hcz6VP94N1Nezc=
MIME-Version: 1.0
In-Reply-To: <20100603135106.7247.A69D9226@jp.fujitsu.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com>
Date: Thu, 3 Jun 2010 15:11:41 +0900
Message-ID: <AANLkTikCp17CnCzHVPtHIP7BQriD9Oddsm5T0W0aricJ@mail.gmail.com>
Subject: Re: [mmotm 0521][PATCH 0/12] various OOM fixes for 2.6.35
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

On Thu, Jun 3, 2010 at 2:48 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
> This patch series is collection of various OOM bugfixes. I think
> all of patches can send to 2.6.35.
> Recently, David Rientjes and Luis Claudio R. Goncalves posted other
> various imporovement. I'll collect such 2.6.36 items and I plan to
> push -mm at next week.

Recently, there are many confusion due to patches related OOM.
You are cleaning up it and looks better than old for review.
Thanks for your great effort.


-- 
Kind regards,
Minchan Kim

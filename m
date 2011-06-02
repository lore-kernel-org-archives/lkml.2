Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab1FBNav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:30:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42469 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab1FBNat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:30:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eMFkkDh498TTmiXst0H+fy5NiwAIwfhQX9gUPdIQyPIO5CApA5r4D4maLJ4SIeEDI+
         P1Gag0kpC1GKNPIM1WsZQr9eJLMwV1sdkRJekj1FcUpa00TCPN7iM2s+Jvh5N8w94MmO
         os+qOzuLuU0a1aIC4TOP8Dr4KR8HYKdNqtQ7c=
MIME-Version: 1.0
In-Reply-To: <1306909519-7286-7-git-send-email-hannes@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
	<1306909519-7286-7-git-send-email-hannes@cmpxchg.org>
Date: Thu, 2 Jun 2011 22:30:48 +0900
Message-ID: <BANLkTi=x_Fm-AcwcRAicJ4BaK1z0tT0u+Q@mail.gmail.com>
Subject: Re: [patch 6/8] vmscan: change zone_nr_lru_pages to take memcg
 instead of scan control
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/1 Johannes Weiner <hannes@cmpxchg.org>:
> This function only uses sc->mem_cgroup from the scan control.  Change
> it to take a memcg argument directly, so callsites without an actual
> reclaim context can use it as well.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I wonder this can be cut out and cab be merged immediately, no ?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab1EOR4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:56:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab1EOR4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:56:37 -0400
Message-ID: <4DD013CB.8080408@redhat.com>
Date: Sun, 15 May 2011 13:56:27 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        minchan.kim@gmail.com
Subject: Re: [PATCH 1/3] vmscan,memcg: memcg aware swap token
References: <4DCD1824.1060801@jp.fujitsu.com> <4DCD189D.2000207@jp.fujitsu.com>
In-Reply-To: <4DCD189D.2000207@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2011 07:40 AM, KOSAKI Motohiro wrote:
> Currently, memcg reclaim can disable swap token even if the swap token
> mm doesn't belong in its memory cgroup. It's slightly risky. If an
> admin creates very small mem-cgroup and silly guy runs contentious heavy
> memory pressure workload, every tasks are going to lose swap token and
> then system may become unresponsive. That's bad.
>
> This patch adds 'memcg' parameter into disable_swap_token(). and if
> the parameter doesn't match swap token, VM doesn't disable it.
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel<riel@redhat.com>

-- 
All rights reversed

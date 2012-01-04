Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2ADRfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:35:06 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37408 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab2ADRfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:35:01 -0500
MIME-Version: 1.0
In-Reply-To: <20120104084611.GA12581@tiehlicka.suse.cz>
References: <1325633632-9978-1-git-send-email-kosaki.motohiro@gmail.com> <20120104084611.GA12581@tiehlicka.suse.cz>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 4 Jan 2012 12:34:39 -0500
Message-ID: <CAHGf_=o-mBAZxAW=vHSKKBCGqtzc+ooXrc9+vHvPoo_t4A9Chg@mail.gmail.com>
Subject: Re: [PATCH 1/2] memcg: root_mem_cgroup makes static
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/4 Michal Hocko <mhocko@suse.cz>:
> On Tue 03-01-12 18:33:51, kosaki.motohiro@gmail.com wrote:
>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>
>> root_mem_cgroup is only referenced from memcontrol.c. It should be static.
>
> This has been already posted by Kirill
> https://lkml.org/lkml/2011/12/23/292

Oops. I haven't noticed.

Thank you, Michal!

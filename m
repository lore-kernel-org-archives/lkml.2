Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab0KNVml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 16:42:41 -0500
Received: from smtp-out.google.com ([74.125.121.35]:19159 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab0KNVmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 16:42:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=OJ1/oPSQi/5qKvEaTlCvPFMXdun4zHfehjI+6u8vREuuE4Zy36fmqxbnwyjvo0xq5W
         hsWlQcDXe7Y0JDyxpP8g==
Date: Sun, 14 Nov 2010 13:42:34 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: 7eggert@gmx.de, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, gspencer@chromium.org,
        piman@chromium.org, wad@chromium.org, olofj@chromium.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] oom: create a resource limit for oom_adj
In-Reply-To: <20101114140237.E010.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011141341360.22262@chino.kir.corp.google.com>
References: <fNMps-1S1-21@gated-at.bofh.it> <E1PGgMk-0001AW-OD@be1.7eggert.dyndns.org> <20101114140237.E010.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Nov 2010, KOSAKI Motohiro wrote:

> I've sent revert patch to linus. We DON'T want to break any userland seriously. 
> So, we reconsider about this area. personally I hope to reintroduce oom_score_adj
> later, but It must don't break current userland.
> 

Nobody is going to stall their development waiting for your patches to be 
merged (especially when you've proposed them four times before and they 
haven't been), so patches in this area should be against Linus' latest 
tree.

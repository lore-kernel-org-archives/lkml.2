Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1K1AmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 19:42:20 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33059 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab1K1AmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 19:42:18 -0500
MIME-Version: 1.0
In-Reply-To: <1322062951-1756-3-git-send-email-hannes@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
	<1322062951-1756-3-git-send-email-hannes@cmpxchg.org>
Date: Mon, 28 Nov 2011 06:12:17 +0530
Message-ID: <CAKTCnzmO6P1B_8kGG5tPOrWAb6PT0byOZ4WQdfWwbaHAX7shww@mail.gmail.com>
Subject: Re: [patch 2/8] mm: unify remaining mem_cont, mem, etc. variable
 names to memcg
From: Balbir Singh <bsingharora@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 9:12 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> From: Johannes Weiner <jweiner@redhat.com>
>
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>


I am not very comfortable with memcgp, I'd prefer the name to
represent something more useful especially when it is an output
parameter. Having said that I don't think it is a stopper for the
patch

Balbir Singh.

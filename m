Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab2AYBzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 20:55:05 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39548 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab2AYBzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 20:55:03 -0500
MIME-Version: 1.0
In-Reply-To: <20120124082352.GA26289@tiehlicka.suse.cz>
References: <CAJd=RBAbFd=MFZZyCKN-Si-Zt=C6dKVUaG-C7s5VKoTWfY00nA@mail.gmail.com>
	<20120123130221.GA15113@tiehlicka.suse.cz>
	<CALWz4izWYb=_svn=UJ1C--pWXv59H2ahn6EJEnTpJv-dT6WGsw@mail.gmail.com>
	<CAJd=RBAuDABE7u1wyc+45ZGoVos5PnxMe6P=ET-CHf-LChTpgw@mail.gmail.com>
	<20120124082352.GA26289@tiehlicka.suse.cz>
Date: Wed, 25 Jan 2012 09:55:01 +0800
Message-ID: <CAJd=RBDj5mtWJG0Byi=97Kuu6LnkwdndDO-AUpeYSCTBEy0P5A@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: fix over reclaiming mem cgroup
From: Hillf Danton <dhillf@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 4:23 PM, Michal Hocko <mhocko@suse.cz> wrote:
> Barriered?
>
pushed out for 3.3-rc2 last night?

Hillf

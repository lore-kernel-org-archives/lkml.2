Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab1IHAtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:49:12 -0400
Received: from shutemov.name ([188.40.19.243]:38260 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757597Ab1IHAtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:49:11 -0400
Date: Thu, 8 Sep 2011 03:49:07 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <bsingharora@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: drain all stocks for the cgroup before read usage
Message-ID: <20110908004906.GA8499@shutemov.name>
References: <1315098933-29464-1-git-send-email-kirill@shutemov.name>
 <20110905085913.8f84278e.kamezawa.hiroyu@jp.fujitsu.com>
 <20110905101607.cd946a46.nishimura@mxp.nes.nec.co.jp>
 <20110907213340.GA7690@shutemov.name>
 <20110908091914.6daeab1e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908091914.6daeab1e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 09:19:14AM +0900, KAMEZAWA Hiroyuki wrote:
> > Should we have field 'ram' (or 'memory') for rss+cache in memory.stat?
> > 
> 
> Why do you think so ?

It may be useful for scripting purpose. Just an idea.

-- 
 Kirill A. Shutemov

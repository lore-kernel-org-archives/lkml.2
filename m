Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab2E3XSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 19:18:48 -0400
Received: from shutemov.name ([176.9.204.213]:43064 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab2E3XSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 19:18:48 -0400
Date: Thu, 31 May 2012 02:20:05 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: David Rientjes <rientjes@google.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>, hannes@cmpxchg.org,
        kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, bsingharora@gmail.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
Message-ID: <20120530232004.GA15423@shutemov.name>
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com>
 <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 02:38:25PM -0700, David Rientjes wrote:
> Why?  Because the information exported by /proc/meminfo is considered by 
> applications to be static whereas the limit of a memcg may change without 
> any knowledge of the application.

Memory hotplug does the same, right?

-- 
 Kirill A. Shutemov

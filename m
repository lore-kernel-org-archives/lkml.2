Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1BQG3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 01:29:09 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:45279 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab1BQG3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 01:29:07 -0500
Date: Thu, 17 Feb 2011 11:58:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] memcg: use native word page statistics counters
Message-ID: <20110217062859.GH3415@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1297920842-17299-1-git-send-email-gthelen@google.com>
 <1297920842-17299-3-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1297920842-17299-3-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg Thelen <gthelen@google.com> [2011-02-16 21:34:02]:

> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> The statistic counters are in units of pages, there is no reason to
> make them 64-bit wide on 32-bit machines.
> 
> Make them native words.  Since they are signed, this leaves 31 bit on
> 32-bit machines, which can represent roughly 8TB assuming a page size
> of 4k.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Greg Thelen <gthelen@google.com>


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir

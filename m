Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab0JFQZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:25:11 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60250 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab0JFQZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:25:09 -0400
Date: Wed, 6 Oct 2010 21:54:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 08/10] memcg: add cgroupfs interface to memcg dirty limits
Message-ID: <20101006162458.GJ4195@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1286175485-30643-1-git-send-email-gthelen@google.com>
 <1286175485-30643-9-git-send-email-gthelen@google.com>
 <20101006133024.GE4195@balbir.in.ibm.com>
 <20101006133244.GF4195@balbir.in.ibm.com>
 <xr93pqvnjnq4.fsf@ninji.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <xr93pqvnjnq4.fsf@ninji.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg Thelen <gthelen@google.com> [2010-10-06 09:21:55]:

> Looks good to me.  I am currently gather performance data on the memcg
> series.  It should be done in an hour or so.  I'll then repost V2 of the
> memcg dirty limits series.  I'll integrate this patch into the series,
> unless there's objection.
>

Please go ahead and incorporate it. Thanks! 

-- 
	Three Cheers,
	Balbir

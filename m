Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0HRP5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:57:16 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:34990 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753806Ab0HRP5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:57:13 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: D9gsO5gVM1k31e7T0.BwA8R3XeloapwsZBC11XrlA1JfiKm
 YveWtWsxZVo1gk.tXr_CxUJir_BYwqyxnvJFtUNZlyyQzJ2heQG5S6mLlLuL
 .wpVNgwGVWbbC0NoKIKR_5RBUn9FeqaWvmEWUyHgkstQ79bCJ_02EkowT1jx
 qTnhlwm7T0KAW.tQwA6os_GzPdX9QEte0R7MiispcPdCSG7u2VVyfZ93q2CN
 AFEBSC5bUND.sj6amYQUJVdn8WPll
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 18 Aug 2010 10:57:09 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Chris Webb <chris@arachsys.com>, Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andi Kleen <andi@firstfloor.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: Over-eager swapping
In-Reply-To: <20100818152103.GA11268@localhost>
Message-ID: <alpine.DEB.2.00.1008181056350.4025@router.home>
References: <20100803042835.GA17377@localhost> <20100803214945.GA2326@arachsys.com> <20100804022148.GA5922@localhost> <AANLkTi=wRPXY9BTuoCe_sDCwhnRjmmwtAf_bjDKG3kXQ@mail.gmail.com> <20100804032400.GA14141@localhost> <20100804095811.GC2326@arachsys.com>
 <20100804114933.GA13527@localhost> <20100804120430.GB23551@arachsys.com> <20100818143801.GA9086@localhost> <20100818144655.GX2370@arachsys.com> <20100818152103.GA11268@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010, Wu Fengguang wrote:

> Andi, Christoph and Lee:
>
> This looks like an "unbalanced NUMA memory usage leading to premature
> swapping" problem.

Is zone reclaim active? It may not activate on smaller systems leading
to an unbalance memory usage between node.



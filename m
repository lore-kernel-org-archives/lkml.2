Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0HRQNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:13:10 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:44277 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750862Ab0HRQNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:13:09 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: n8v7JN8VM1lbrMzdqkIRpoXfpMDXhNmES8aHd1YX_kARj69
 JOuvboy6y8Tl64hUEeDX2rDqEruPZL665N8Plr_It1eRBtVaVt24qBECm40V
 gEj7JQwuCFZxL44QxFvlF.Pe8hVr9u7dFZn8FaRupT8K8CVGP9l2t.eUUZTG
 0uMfb32pvO9jWJCQ1xLK33nOa6gFN5_s7Y_IEX99LLU6i3oGWUp.Sk00XIqz
 q9GJ8Dd.WQ0CTiRP.zANYoNveCro-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 18 Aug 2010 11:13:03 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Chris Webb <chris@arachsys.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: Over-eager swapping
In-Reply-To: <20100818155825.GA2370@arachsys.com>
Message-ID: <alpine.DEB.2.00.1008181112510.6294@router.home>
References: <20100804022148.GA5922@localhost> <AANLkTi=wRPXY9BTuoCe_sDCwhnRjmmwtAf_bjDKG3kXQ@mail.gmail.com> <20100804032400.GA14141@localhost> <20100804095811.GC2326@arachsys.com> <20100804114933.GA13527@localhost> <20100804120430.GB23551@arachsys.com>
 <20100818143801.GA9086@localhost> <20100818144655.GX2370@arachsys.com> <20100818152103.GA11268@localhost> <1282147034.77481.33.camel@useless.localdomain> <20100818155825.GA2370@arachsys.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010, Chris Webb wrote:

> > != 0.  And even then, zone reclaim should only reclaim file pages, not
> > anon.  In theory...
>
> Hi. This is zero on all our machines:
>
> # sysctl vm.zone_reclaim_mode
> vm.zone_reclaim_mode = 0

Set it to 1.


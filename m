Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2JOOGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:06:38 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57274 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab2JOOGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:06:35 -0400
Message-ID: <507C183C.2070106@linux.vnet.ibm.com>
Date: Mon, 15 Oct 2012 07:05:48 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
References: <20121012125708.GJ10110@dhcp22.suse.cz>
In-Reply-To: <20121012125708.GJ10110@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101514-7182-0000-0000-000002D3E30C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 05:57 AM, Michal Hocko wrote:
> I would like to resurrect the following Dave's patch. The last time it
> has been posted was here https://lkml.org/lkml/2010/9/16/250 and there
> didn't seem to be any strong opposition. 
> Kosaki was worried about possible excessive logging when somebody drops
> caches too often (but then he claimed he didn't have a strong opinion
> on that) but I would say opposite. If somebody does that then I would
> really like to know that from the log when supporting a system because
> it almost for sure means that there is something fishy going on. It is
> also worth mentioning that only root can write drop caches so this is
> not an flooding attack vector.

Just read through the patch again.  Still looks great to me.

Thanks for bringing it up again, Michal!


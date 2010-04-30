Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894Ab0D3SNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:13:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:44970 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933880Ab0D3SM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:12:58 -0400
Message-ID: <4BDB1D42.10806@kernel.org>
Date: Fri, 30 Apr 2010 20:11:14 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 2/2] workqueues: export keventd_wq
References: <1272429119-12103-1-git-send-email-arve@android.com> <20100428194028.GA16389@redhat.com> <4BD89922.1040306@kernel.org> <201004282308.10751.rjw@sisk.pl> <20100429185851.GA13862@redhat.com> <20100429194447.GA17280@redhat.com> <20100429194545.GC17280@redhat.com> <4BDA67C1.7050709@kernel.org> <t2gd6200be21004292239r582b8a43l2409491b8d32ef1b@mail.gmail.com> <4BDA700C.3050509@kernel.org> <20100430180520.GB9043@redhat.com>
In-Reply-To: <20100430180520.GB9043@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Apr 2010 18:11:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/30/2010 08:05 PM, Oleg Nesterov wrote:
> Right, but this allows to make schedule_xxx/flush_scheduled_work
> inline and kill more EXPORT_SYMBOL's, and cmwq exports it anyway
> (iirc it also renames it).

Yeah, the 'iirc' part was why I didn't want to export it at this point. :-)

> OK. Let's forget this patch. We can unify schedule_suspend_blocking_work
> and queue_suspend_blocking_work later, or Arve can add this export into
> his patch (without EXPORT_SYMBOL) - either way I agree. This is very
> minor issue, I regret I originated this almost offtopic noise ;)

And, again, yeah, let's do it later.

Thanks.

-- 
tejun

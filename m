Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262Ab0D3S6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:58:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:60359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756632Ab0D3REY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:04:24 -0400
Message-ID: <4BDA6785.8040906@kernel.org>
Date: Fri, 30 Apr 2010 07:15:49 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5?= =?ISO-8859-1?Q?g?= 
	<arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 1/2] workqueues: flush_delayed_work: keep the original
 workqueue for re-queueing
References: <1272429119-12103-1-git-send-email-arve@android.com> <20100428194028.GA16389@redhat.com> <4BD89922.1040306@kernel.org> <201004282308.10751.rjw@sisk.pl> <20100429185851.GA13862@redhat.com> <20100429194447.GA17280@redhat.com> <20100429194516.GB17280@redhat.com>
In-Reply-To: <20100429194516.GB17280@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Apr 2010 05:15:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/29/2010 09:45 PM, Oleg Nesterov wrote:
> flush_delayed_work() always uses keventd_wq for re-queueing,
> but it should use the workqueue this dwork was queued on.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

I'll queue it through the wq tree I have.

Thanks.

-- 
tejun

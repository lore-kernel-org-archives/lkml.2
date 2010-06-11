Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010Ab0FKBCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 21:02:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46083 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab0FKBCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 21:02:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Jun 2010 09:57:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1/2] Cleanup: use for_each_online_cpu in vmstat
Message-Id: <20100611095738.ff9e5b35.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1276176526-2952-1-git-send-email-minchan.kim@gmail.com>
References: <1276176526-2952-1-git-send-email-minchan.kim@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010 22:28:46 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> The sum_vm_events passes cpumask for for_each_cpu.
> But it's useless since we have for_each_online_cpu.
> Althougth it's tirival overhead, it's not good about
> coding consistency.
> 
> Let's use for_each_online_cpu instead of for_each_cpu with
> cpumask argument.
> 
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



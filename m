Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab0FMLYy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 07:24:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45020 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab0FMLYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 07:24:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [mmotm] Cleanup: use for_each_online_cpu in vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux.com>
In-Reply-To: <1276176751-2990-1-git-send-email-minchan.kim@gmail.com>
References: <1276176751-2990-1-git-send-email-minchan.kim@gmail.com>
Message-Id: <20100613162540.6157.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 13 Jun 2010 20:24:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry. It's not [1/2] and I used Chrisopth's old mail address.
> Resend. 
> 
> --
> 
> The sum_vm_events passes cpumask for for_each_cpu.
> But it's useless since we have for_each_online_cpu.
> Althougth it's tirival overhead, it's not good about
> coding consistency.
> 
> Let's use for_each_online_cpu instead of for_each_cpu with
> cpumask argument.
> 
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Christoph Lameter <cl@linux.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Thank you.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab1EPUkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:40:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43464
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754049Ab1EPUkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:40:42 -0400
Date: Mon, 16 May 2011 13:40:10 -0700 (PDT)
Message-Id: <20110516.134010.39174667.davem@davemloft.net>
To: kosaki.motohiro@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] sparc: convert old cpumask API into new one
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110429001547.3D6C.A69D9226@jp.fujitsu.com>
References: <20110429001547.3D6C.A69D9226@jp.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 29 Apr 2011 00:14:08 +0900 (JST)

> Adapt new API. Almost change is trivial, most important change are to
> remove following like =operator.
> 
>  cpumask_t cpu_mask = *mm_cpumask(mm);
>  cpus_allowed = current->cpus_allowed;
> 
> Because cpumask_var_t is =operator unsafe. These usage might prevent
> kernel core improvement.
> 
> No functional change.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Applied, thanks.

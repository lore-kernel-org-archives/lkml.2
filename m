Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab2JIQTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:19:01 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab2JIQS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:18:59 -0400
Date: Tue, 9 Oct 2012 16:18:47 +0200
From: Richard Weinberger <richard@nod.at>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: dedekind1@gmail.com, dwmw2@infradead.org, yongjun_wei@trendmicro.com.cn,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ubi: use list_move_tail instead of
 list_del/list_add_tail
Message-ID: <20121009161847.79031abb@spider.haslach.nod.at>
In-Reply-To: <CAPgLHd_AHHe7=H18K54LvbiS0M7_w1vTMOxwwxgVdRaiXNN-OA@mail.gmail.com>
References: <CAPgLHd_AHHe7=H18K54LvbiS0M7_w1vTMOxwwxgVdRaiXNN-OA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tue, 9 Oct 2012 14:14:21 +0800
schrieb Wei Yongjun <weiyj.lk@gmail.com>:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using list_move_tail() instead of list_del() + list_add_tail().
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard

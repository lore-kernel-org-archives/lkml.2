Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab2HTIjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:39:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34049 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2HTIji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:39:38 -0400
Message-ID: <1345451964.23018.16.camel@twins>
Subject: Re: [PATCH] sched: add missing call for calc_load_exit_idle
From: Peter Zijlstra <peterz@infradead.org>
To: Charles Wang <muming.wq@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, dsmythies@telus.net,
        Charles Wang <muming.wq@taobao.com>
Date: Mon, 20 Aug 2012 10:39:24 +0200
In-Reply-To: <1345449754-27130-1-git-send-email-muming.wq@gmail.com>
References: <1345449754-27130-1-git-send-email-muming.wq@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 16:02 +0800, Charles Wang wrote:
> From Charles Wang <muming.wq@taobao.com>
> 
> Azat Khuzhin reported "high loadavg in linux-3.6"
> 
> After checking for upstream's code, I found Peter's patch
> (Commit id:5167e8d5417bf5c322a703d2927daec727ea40dd) not be
> fully applied, missing the call for calc_load_exit_idle.
> After that idle exit in sampling window will always be calculated
>  to non-idle, and the load will be higher than normal.
> 
> This patch add the missing call for calc_load_exit_idle.
> 
> Signed-off-by: Charles Wang <muming.wq@taobao.com>

Argh! how the @#$# did that happen..

Thanks for spotting it.

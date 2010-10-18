Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0JRDEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 23:04:34 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:46110 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751920Ab0JRDEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 23:04:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ARgk7CF1xOhdc9p23SNDrELDDxX8PlI4eqBt3uLGIVaXJlRrc1vkAHUdKnX6sWVw+KCtrqTW4k19YGkXtrpopDHB7p7K6qYYXDfhfnUWjDpcpECnMsDjW2/mX2dY+RkH;
Date: Sun, 17 Oct 2010 20:03:47 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.36-rc7 2/2] shpchp: update workqueue usage
Message-ID: <20101017200347.5ca09aed@jbarnes-desktop>
In-Reply-To: <4CB8698A.8030202@kernel.org>
References: <4CB86966.5020606@kernel.org>
	<4CB8698A.8030202@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010 16:47:38 +0200
Tejun Heo <tj@kernel.org> wrote:

> * Rename shpchp_wq to shpchp_ordered_wq and add non-ordered shpchp_wq
>   which is used instead of the system workqueue.  This is to remove
>   the use of flush_scheduled_work() which is deprecated and scheduled
>   for removal.
> 
> * With cmwq in place, there's no point in creating workqueues lazily.
>   Create both shpchp_wq and shpchp_ordered_wq upfront.
> 
> * Include workqueue.h from shpchp.h.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---

...and dropped again.  Hadn't realized they depend on stuff from your
workqueue tree.  Please just include them there assuming Kenji-san
doesn't nack them.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center

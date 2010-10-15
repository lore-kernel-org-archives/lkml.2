Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab0JOTxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:53:17 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:38120 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756711Ab0JOTxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:53:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bp3UNbJHVZzDkwwM4nKrT6izNOqn4ee/3E8ie5X8X+OwmNVdAhzX+Nf3u1fiqmmgbWu8RD/FH/4fHDuKBN+0PabNbn+vSpMsQZ2m1R/Tj//sFUgeZg6TB670YWTLJEZk;
Date: Fri, 15 Oct 2010 12:52:57 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH v2.6.36-rc7 2/2] shpchp: update workqueue usage
Message-ID: <20101015125257.73e8d8df@jbarnes-desktop>
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

Applied these two, thanks.  I think Kenji-san will probably let me know
if pciehp suddenly breaks as a result. :)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

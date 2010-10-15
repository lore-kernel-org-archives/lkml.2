Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab0JOURk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:17:40 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:37305 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756946Ab0JOURc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:17:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=rUjdnzZxTAn2ndzdSDJVB7be1uWCOMUAmSoyQgGBy4OJIb30nFt0rzRw6PuglmZXn9nXVBY6A6WIUV5vMSaDxVU7FN8GBfgcbSxV4jVRG9e+4C944x9UZv4gxlUEq9dM;
Date: Fri, 15 Oct 2010 13:17:14 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH v2.6.36-rc7 2/2] shpchp: update workqueue usage
Message-ID: <20101015131714.432a7647@jbarnes-desktop>
In-Reply-To: <4CB8B4B8.8090501@kernel.org>
References: <4CB86966.5020606@kernel.org>
	<4CB8698A.8030202@kernel.org>
	<20101015125257.73e8d8df@jbarnes-desktop>
	<4CB8B4B8.8090501@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010 22:08:24 +0200
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 10/15/2010 09:52 PM, Jesse Barnes wrote:
> >> * Rename shpchp_wq to shpchp_ordered_wq and add non-ordered shpchp_wq
> >>   which is used instead of the system workqueue.  This is to remove
> >>   the use of flush_scheduled_work() which is deprecated and scheduled
> >>   for removal.
> >>
> >> * With cmwq in place, there's no point in creating workqueues lazily.
> >>   Create both shpchp_wq and shpchp_ordered_wq upfront.
> >>
> >> * Include workqueue.h from shpchp.h.
> > 
> > Applied these two, thanks.  I think Kenji-san will probably let me know
> > if pciehp suddenly breaks as a result. :)
> 
> Just in case, these are in no way aimed for v2.6.36.  They are at the
> earliest for v2.6.37-rc1.  Thanks a lot.

Of course, everything I've applied today has been for 2.6.37; 2.6.36 is
well closed now, there are no critical missing PCI fixes that I'm aware
of.

-- 
Jesse Barnes, Intel Open Source Technology Center

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab2J3ClZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 22:41:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab2J3ClX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 22:41:23 -0400
Date: Mon, 29 Oct 2012 19:41:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH v3 4/9] clear the memory to store struct page
Message-Id: <20121029194109.9a910c11.akpm@linux-foundation.org>
In-Reply-To: <508F38E9.1050604@cn.fujitsu.com>
References: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com>
	<1350629202-9664-5-git-send-email-wency@cn.fujitsu.com>
	<508A5B66.7000309@cn.fujitsu.com>
	<20121029141012.4c1c2b07.akpm@linux-foundation.org>
	<508F38E9.1050604@cn.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2012 10:18:17 +0800 Wen Congyang <wency@cn.fujitsu.com> wrote:

> At 10/30/2012 05:10 AM, Andrew Morton Wrote:
> > On Fri, 26 Oct 2012 17:44:06 +0800
> > Wen Congyang <wency@cn.fujitsu.com> wrote:
> > 
> >> This patch has been acked by kosaki motohiro. Is it OK to be merged
> >> into -mm tree?
> > 
> > I'd already merged the v2 patchset when you later sent out the v3
> > patchset which contains some of the material from v2 plus more things.
> > 
> > I can drop all of v2 and remerge v3.  But I see from the discussion
> > under "[PATCH v3 6/9] memory-hotplug: update mce_bad_pages when
> > removing the memory" that you intend to send out a v4 patchset.
> 
> OK, I will send out a v4 patchset.

Thanks.

> Do I need to resend the patch
> which is in -mm tree and has no comment?

I wonder which patch that is!

Sure, send everything.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab2I0VS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:18:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab2I0VS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:18:58 -0400
Date: Thu, 27 Sep 2012 14:18:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: wency@cn.fujitsu.com, Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 0/4] bugfix for memory hotplug
Message-Id: <20120927141856.732ded79.akpm@linux-foundation.org>
In-Reply-To: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com>
References: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll assume that you will be preparing a new revision of these patches.

We have another patch series today called "memory_hotplug: fix memory
hotplug bug", from another Fujitsu person.  But you people aren't
cc'ing each other.  Please do so and please review and if possible test
each others' work?

I'm assuming that the "memory_hotplug: fix memory hotplug bug" series
will also go through another revision?  I don't think I was cc'ed on
the second patch in that series btw.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab0KVBMw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:12:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545Ab0KVBMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:12:31 -0500
Date: Sun, 21 Nov 2010 16:56:58 -0800
From: Greg KH <gregkh@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        Paul Mundt <lethal@linux-sh.org>, Andi Kleen <ak@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org
Subject: Re: [patch 2/2 v2] mm: add node hotplug emulation
Message-ID: <20101122005658.GA6710@suse.de>
References: <20101118062715.GD17539@linux-sh.org> <20101118052750.GD2408@shaohui> <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com> <20101119003225.GB3327@shaohui> <alpine.DEB.2.00.1011201645230.10618@chino.kir.corp.google.com> <alpine.DEB.2.00.1011201826140.12889@chino.kir.corp.google.com> <alpine.DEB.2.00.1011201827540.12889@chino.kir.corp.google.com> <20101121173438.GA3922@suse.de> <alpine.DEB.2.00.1011211346160.26304@chino.kir.corp.google.com> <alpine.DEB.2.00.1011211505440.30377@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011211505440.30377@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 03:08:17PM -0800, David Rientjes wrote:
> Add an interface to allow new nodes to be added when performing memory
> hot-add.  This provides a convenient interface to test memory hotplug
> notifier callbacks and surrounding hotplug code when new nodes are
> onlined without actually having a machine with such hotpluggable SRAT
> entries.
> 
> This adds a new debugfs interface at /sys/kernel/debug/hotplug/add_node

The rule for debugfs is "there are no rules", but perhaps you might want
to name "hotplug" a bit more specific for what you are doing?  "hotplug"
means pretty much anything these days, so how about s/hotplug/node/
instead as that is what you are controlling.

Just a suggestion...

greg k-h

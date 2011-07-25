Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab1GYPWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:22:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab1GYPWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:22:43 -0400
Date: Mon, 25 Jul 2011 08:20:38 -0700
From: Greg KH <gregkh@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH v2 1/6] perf: Add interface to add general events to sysfs
Message-ID: <20110725152038.GA23356@suse.de>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
 <1310740503-15608-2-git-send-email-ming.m.lin@intel.com>
 <1310996068.13765.67.camel@twins>
 <1311581475.3938.1477.camel@minggr.sh.intel.com>
 <1311582723.2617.50.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311582723.2617.50.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 10:32:03AM +0200, Peter Zijlstra wrote:
> On Mon, 2011-07-25 at 16:11 +0800, Lin Ming wrote:
> > It's strange that I didn't find a way to check if a directory is present
> > in sysfs. Any hint?
> 
> sysfs is voodoo for me, best I can come up with is, ask the sysfs
> folks ;-)
> 
> Kay, Greg?

What are you trying to do here specifically?

sysfs is not ment to be walked from within the kernel, only from
userspace.  Perhaps that is your problem here?

greg k-h

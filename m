Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab0KBOiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 10:38:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:9564 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab0KBOiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:38:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,282,1286175600"; 
   d="scan'208";a="343595722"
Date: Tue, 2 Nov 2010 22:01:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesper Juhl <jj@chaosbits.net>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Add Kconfig option for default swappiness
Message-ID: <20101102140119.GA8294@localhost>
References: <1288668052-32036-1-git-send-email-bgamari.foss@gmail.com>
 <alpine.DEB.2.00.1011012030100.12298@chino.kir.corp.google.com>
 <87oca7evbo.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87oca7evbo.fsf@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 08:58:19PM +0800, Ben Gamari wrote:
> On Mon, 1 Nov 2010 20:33:10 -0700 (PDT), David Rientjes <rientjes@google.com> wrote:
> > And they can't use an init script to tune /proc/sys/vm/swappiness 
> > because...?
> 
> Packaging concerns, as I mentioned before,
> 
> On Mon, Nov 01, 2010 at 08:52:30AM -0400, Ben Gamari wrote:
> > Ubuntu ships different kernels for desktop and server usage. From a
> > packaging standpoint it would be much nicer to have this set in the
> > kernel configuration. If we were to throw the setting /etc/sysctl.conf
> > the kernel would depend upon the package containing sysctl(8)
> > (procps). We'd rather avoid this and keep the default kernel
> > configuration in one place.
> 
> In short, being able to specify this default in .config is just far
> simpler from a packaging standpoint than the alternatives.

It's interesting to know what value you plan to use for your
desktop/server systems and the rationals (is it based on any
testing results?). And why it's easier to do it in kernel (hope it's
not because of trouble communicating with the user space packaging
team).

Thanks,
Fengguang

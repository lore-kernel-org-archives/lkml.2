Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab2EUPW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:22:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab2EUPW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:22:26 -0400
Date: Mon, 21 May 2012 17:22:13 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120521152212.GE28930@dhcp-26-207.brq.redhat.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <20120521082240.GA31407@gmail.com>
 <20120521093648.GC28930@dhcp-26-207.brq.redhat.com>
 <20120521124025.GC17065@gmail.com>
 <20120521144812.GD28930@dhcp-26-207.brq.redhat.com>
 <20120521145904.GA7068@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521145904.GA7068@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 04:59:04PM +0200, Ingo Molnar wrote:
> 
> * Alexander Gordeev <agordeev@redhat.com> wrote:
> Your other two patches looked sensible - will they apply fine 
> after each other, without the round-robin patch which is still 
> under discussion, or is there a dependency?

1/3 will apply cleanly; not worth worrying though -- whitespace oneliner
3/3 depends on 2/3 round-robin patch, and doubtful :)

> Thanks,
> 
> 	Ingo

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

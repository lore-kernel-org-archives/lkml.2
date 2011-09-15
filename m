Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab1IOJKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 05:10:48 -0400
Received: from claw.goop.org ([74.207.240.146]:38890 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab1IOJKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 05:10:47 -0400
Message-ID: <4E71C116.4080400@goop.org>
Date: Thu, 15 Sep 2011 02:10:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the xen tree
References: <20110915152723.b3bdd6a5478c810245fabca1@canb.auug.org.au>
In-Reply-To: <20110915152723.b3bdd6a5478c810245fabca1@canb.auug.org.au>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2011 10:27 PM, Stephen Rothwell wrote:
> Hi all,
>
> After merging the xen tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> arch/x86/xen/time.c: In function 'xen_set_wallclock':
> arch/x86/xen/time.c:204:25: error: storage size of 'op' isn't known
> arch/x86/xen/time.c:211:11: error: 'XENPF_settime' undeclared (first
use in this function)
> arch/x86/xen/time.c:211:11: note: each undeclared identifier is
reported only once for each function it appears in
> arch/x86/xen/time.c:216:2: error: implicit declaration of function
'HYPERVISOR_dom0_op'
> arch/x86/xen/time.c:204:25: warning: unused variable 'op'
>
> Caused by commit 7b11a83f592a ("xen/dom0: set wallclock time in Xen").
>
> I have used teh xen tree from next-20110914 for today.

Thanks, I'll drop that for now.

    J




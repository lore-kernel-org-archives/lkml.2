Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab2JRDDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 23:03:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26844 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab2JRDDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 23:03:02 -0400
X-IronPort-AV: E=Sophos;i="4.80,605,1344182400"; 
   d="scan'208";a="6019697"
Message-ID: <507F6EB3.7030705@cn.fujitsu.com>
Date: Thu, 18 Oct 2012 10:51:31 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        miaox@cn.fujitsu.com, wency@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's node.
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com> <1349780256.7880.12.camel@twins> <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com> <1349815676.7880.85.camel@twins> <alpine.DEB.2.00.1210091617260.10143@chino.kir.corp.google.com> <1349860216.7880.105.camel@twins> <alpine.DEB.2.00.1210101324000.28583@chino.kir.corp.google.com> <20121010133709.7eaefcdb.akpm@linux-foundation.org> <alpine.DEB.2.00.1210101351050.31237@chino.kir.corp.google.com> <alpine.DEB.2.00.1210171749150.20813@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210171749150.20813@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/18 10:52:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/18 10:52:24,
	Serialize complete at 2012/10/18 10:52:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 08:52 AM, David Rientjes wrote:
> On Wed, 10 Oct 2012, David Rientjes wrote:
>
> Ok, so it's been a week and these patches are still in -mm.  This is what
> I was afraid of: patches that both Peter and I nacked sitting in -mm and
> allow a NULL pointer dereference because no alternative patch exists yet
> to fix the issue correctly.
>
> Tang and Wen, are you intending on addressing these problems (i.e. not
> touching the acpi code at all and rather clearing cpu-to-node mappings at
> node hot-remove) as we've discussed or do I need to do it myself?

Hi David,

We are working on this problem. Since it is complicated, it really
takes us some time. Sorry for the delay. :)

Actually, we intend to clear cpu-to-node mappings when a whole node is
removed. But the node hot-plug code is still under development, so I
think Wen will send a fix patch soon. :)

Thanks.

>
> Thanks.
>


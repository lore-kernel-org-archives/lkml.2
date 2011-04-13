Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1DMSfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:35:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36408 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab1DMSfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:35:23 -0400
Message-ID: <4DA5ECD6.3000409@zytor.com>
Date: Wed, 13 Apr 2011 11:35:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: stefano.stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, jeremy@goop.org, mingo@elte.hu,
        yinghai@kernel.org
Subject: Re: [PATCH 2/4] x86,xen: introduce x86_init.mapping.pagetable_reserve
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop> <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com> <4DA48EA9.70109@kernel.org> <20110413180348.GB19390@dumpdata.com>
In-Reply-To: <20110413180348.GB19390@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 11:03 AM, Konrad Rzeszutek Wilk wrote:
> 
> Peter,
> 
> I stuck this and some of the other in this thread on 'stable/bug-fixes-rc3'
> (git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git). But before
> I send them to Linus to pull I need your OK? Would it be OK if I stuck
> your Ack on the patch?
> 
> Or you could take this patch (the one I stuck in my tree has the description
> a bit modified so I recommend that one).
> 

You have my extremely firm NAK until the intended semantics of the new
hook is explained in detail.

	-hpa

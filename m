Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab1LFSPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:15:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37555 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab1LFSPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:15:01 -0500
Message-ID: <4EDE5B36.2000203@kernel.org>
Date: Tue, 06 Dec 2011 10:13:10 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Arnaud Lacombe <lacombar@gmail.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86-32 PAE-enabled kernel fails to boot with 64GB of RAM
References: <CACqU3MXMAP-7LtVWHENNAQSS+B0c5qVcdWq=4NFGNACxkTRYzg@mail.gmail.com> <20111206102628.GC1342@tiehlicka.suse.cz>
In-Reply-To: <20111206102628.GC1342@tiehlicka.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 02:26 AM, Michal Hocko wrote:
> 
> Quoting from Documentation/vm/highmem.txt:
> "
> The general recommendation is that you don't use more than 8GiB on a
> 32-bit machine - although more might work for you and your workload,
> you're pretty much on your own - don't expect kernel developers to
> really care much if things come apart.
> "
> 

Still, I suspect the failure to cap the memory space... it still
*should* at least limp along.  But yes, at some point the wheels really
will just come off the bus.

Does specifying a kernel"mem=" option (thereby capping the memory
artificially) work?

	-hpa


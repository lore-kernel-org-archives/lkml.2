Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1LUGlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 01:41:09 -0500
Received: from snt0-omc4-s34.snt0.hotmail.com ([65.55.90.237]:9765 "EHLO
	snt0-omc4-s34.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733Ab1LUGlI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 01:41:08 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Dec 2011 01:41:07 EST
Message-ID: <SNT125-W26894BC9E91209254F0941C3A50@phx.gbl>
X-Originating-IP: [50.47.182.211]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@kernel.org>, <mhocko@suse.cz>
CC: <lacombar@gmail.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: x86-32 PAE-enabled kernel fails to boot with 64GB of RAM
Date: Tue, 20 Dec 2011 22:34:55 -0800
Importance: Normal
In-Reply-To: <4EDE5B36.2000203@kernel.org>
References: <CACqU3MXMAP-7LtVWHENNAQSS+B0c5qVcdWq=4NFGNACxkTRYzg@mail.gmail.com>
 <20111206102628.GC1342@tiehlicka.suse.cz>,<4EDE5B36.2000203@kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 21 Dec 2011 06:34:56.0212 (UTC) FILETIME=[A77B4140:01CCBFAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On 12/06/2011 02:26 AM, Michal Hocko wrote:
> >
> > Quoting from Documentation/vm/highmem.txt:
> > "
> > The general recommendation is that you don't use more than 8GiB on a
> > 32-bit machine - although more might work for you and your workload,
> > you're pretty much on your own - don't expect kernel developers to
> > really care much if things come apart.
> > "
> >
>
> Still, I suspect the failure to cap the memory space... it still
> *should* at least limp along. But yes, at some point the wheels really
> will just come off the bus.
>
> Does specifying a kernel"mem=" option (thereby capping the memory
> artificially) work?

FYI Windows when set to 3G/1G VA split with PAE enabled caps to 16GB of RAM.
Yuhong Bao 		 	   		  
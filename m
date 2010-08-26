Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab0HZFuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 01:50:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62715 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab0HZFuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 01:50:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=At9PaMipCsOBOXVQPvthvoGcErTWitPnoL+7MxNBGrszxAZ++A/uSPKTUoqnT8kOPx
         PvjofOhRsOsfgJoAOa7NU7xuZpBBw368wufpLngHTO7wgT5yC30Uw+nmYLiF06QSeXLv
         JFUkwNtNMosuervLig2ef3Hb55fOVoIzO+p74=
Date: Thu, 26 Aug 2010 13:54:17 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawel Osciak <p.osciak@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
Message-ID: <20100826055417.GA5157@cr0.nay.redhat.com>
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
 <1282310110.2605.976.camel@laptop>
 <20100825155814.25c783c7.akpm@linux-foundation.org>
 <20100826095857.5b821d7f.kamezawa.hiroyu@jp.fujitsu.com>
 <op.vh0wektv7p4s8u@localhost>
 <20100826115017.04f6f707.kamezawa.hiroyu@jp.fujitsu.com>
 <20100826124434.6089630d.kamezawa.hiroyu@jp.fujitsu.com>
 <op.vh01hi2m7p4s8u@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vh01hi2m7p4s8u@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 06:01:56AM +0200, Michał Nazarewicz wrote:
>KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>128MB...too big ? But it's depend on config.
>
>On embedded systems it may be like half of the RAM.  Or a quarter.  So bigger
>granularity could be desired on some platforms.
>
>>IBM's ppc guys used 16MB section, and recently, a new interface to shrink
>>the number of /sys files are added, maybe usable.
>>
>>Something good with this approach will be you can create "cma" memory
>>before installing driver.
>
>That's how CMA works at the moment.  But if I understand you correctly, what
>you are proposing would allow to reserve memory *at* *runtime* long after system
>has booted.  This would be a nice feature as well though.
>

Yeah, if we can do this, that will avoid rebooting for kdump to reserve
memory.

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab0INTht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:37:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57237 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab0INThr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XeewqDjr8Nov6YSLNziRxJFFbt3D6jICmGbw99X5d+PppApnzCgopiNlNG1iLvKBTk
         syfBUaaAX+VJyjaXX25rGFKQGhGJdHLOeFhW3gQE6Gyl6OhZ98S3XvB63G/hXFo8Xf5Q
         4ybfZijGoguVgS4du9W7QZUuK1xc0CKPFG9bM=
Date: Tue, 14 Sep 2010 23:34:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
	unknown NMI
Message-ID: <20100914193449.GA9797@lenovo>
References: <20100913141140.GB27371@redhat.com> <20100913172438.37443bf7@basil.nowhere.org> <20100913154750.GA26290@redhat.com> <20100913185721.59ad9b4d@basil.nowhere.org> <20100913175346.GC26290@redhat.com> <20100913200707.3b31429e@basil.nowhere.org> <20100913182354.GE26290@redhat.com> <20100913203654.26724055@basil.nowhere.org> <20100913193655.GF26290@redhat.com> <20100914122131.GF12425@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914122131.GF12425@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 02:21:31PM +0200, Ingo Molnar wrote:
> 
... 
> The proper approach would be not to add hacks to the NMI code but to 
> implement southbridge drivers - which would also have NMI callbacks. 
> These are unchartered waters, but variance in that space is reducing 
> systematically so it would be worth a shot.
> 
> Thanks,
> 
> 	Ingo

Hi Ingo,

while there is a conversation about makeing NMI handler robust/modern or
whatever, I think the naming Huang has implemented for NMI Stat&Ctrl
registers/ports look quite good and convenient (I thought about this times
ago when being merging nmi-32/64 code but didn't implemented it properly).
So I presume perhaps we could merge this snippets first? Or I miss something
on discussion in general?

	-- Cyrill

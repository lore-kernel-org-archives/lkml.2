Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1LIU2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:28:52 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:22638 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab1LIU2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:28:51 -0500
Date: Fri, 9 Dec 2011 21:28:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org, trenn@suse.de, davej@redhat.com, axboe@kernel.dk,
        hpa@zytor.com, herbert@gondor.hengli.com.au, ying.huang@intel.com,
        lenb@kernel.org
Subject: Re: [PATCH 01/10] Add driver auto probing for x86 features
Message-ID: <20111209212842.0b2ec9c7@endymion.delvare>
In-Reply-To: <4EE26E8F.9010000@linux.intel.com>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
	<1323304882-27953-2-git-send-email-andi@firstfloor.org>
	<20111208103540.4778b896@endymion.delvare>
	<20111208144516.GE24062@one.firstfloor.org>
	<20111209211601.08dabc88@endymion.delvare>
	<4EE26E8F.9010000@linux.intel.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Dec 2011 12:24:47 -0800, Andi Kleen wrote:
> 
> > Can you guarantee that there is no asymmetric system already working
> > today?
> 
> I used to have an asymmetric system myself, but we generally subset the 
> CPU feature
> flags to be the same everywhere and I didn't change any per CPU stepping 
> checks
> as they were there.
> 
> >   If you can't, then your approach could cause a regression. This
> > is why I am asking for an API change to let drivers pass a specific CPU
> > to x86_match_cpu(). There are at least two drivers who would take
> > benefit of this. Your patch set is supposed to only add driver
> > auto-loading, and while cleaning up the code in the process is nice, I
> > think you should avoid driver behavior changes, these are out of scope
> > for such a patch set.
> 
> I undoed that change to the coretemp driver

Thanks.

> and there's no other AFAIK.

via-cputemp was affected as well.

> Generally most drivers only check the boot cpu.

-- 
Jean Delvare

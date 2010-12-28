Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0L1QSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 11:18:20 -0500
Received: from mail.wdtv.com ([66.118.69.84]:54265 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab0L1QSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 11:18:16 -0500
From: Gene Heskett <gene.heskett@gmail.com>
To: Mike Galbraith <mgalbraith@suse.de>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
Date: Tue, 28 Dec 2010 11:18:11 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.36.1-latencyfix; KDE/4.5.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20101213224434.7495edb2@annuminas.surriel.com> <201012280108.12807.gene.heskett@gmail.com> <1293517008.6930.21.camel@marge.simson.net>
In-Reply-To: <1293517008.6930.21.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012281118.11760.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 28, 2010, Mike Galbraith wrote:
>On Tue, 2010-12-28 at 01:08 -0500, Gene Heskett wrote:
>> On Tuesday, December 28, 2010, Mike Galbraith wrote:
>> >(either it's christmas, or nobody cares to try it.  ho ho hum:)
>> 
>> Mike, I'd be glad to try it, but the last kernel I was able to make the
>> nvidia drivers install on was 2.6.36.1-latencyfix, which had your
>> earier patches in it, and it is working _very_ well.
>
>It wouldn't do diddly spit by itself anyway, needs someone to stick
>yield_to(amigo) in interesting spots.  Might not do diddly spit even
>then :)
>
>	-Mike

Oh, in that case it will eventually filter down to me anyway after the rest 
of this list beats on it to see what falls out.  But I occasionally like to 
be part of the filtering media as long as I don't bleed too much. ;-)

Thanks Mike.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Without facts, the decision cannot be made logically.  You must rely on
your human intuition.
		-- Spock, "Assignment: Earth", stardate unknown

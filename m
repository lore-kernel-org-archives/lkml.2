Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934Ab2EPMJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:09:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53479 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab2EPMJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:09:07 -0400
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <pantelis.antoniou@gmail.com>
In-Reply-To: <54348.1337113582@turing-police.cc.vt.edu>
Date: Wed, 16 May 2012 15:08:56 +0300
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mou Chen <hi3766691@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, torvalds@linux-foundation.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3AF99A8F-BF71-43BD-ADB8-4A1FF53F9FFF@gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com> <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com> <CANQmPXj_81NBBrTYCkhUO1k1i4WVu0iHwY1_10wDVOFWCSkvsw@mail.gmail.com> <CAKfTPtBhPpQyr1qugbMzq2nENh+zBT+zx_nWQpQ9NPbF=+ppcQ@mail.gmail.com> <833A8DB8-1AB4-45E4-8D44-14A0D782807D@gmail.com> <1337077714.27694.21.camel@twins> <9093E8BA-80E4-4113-B036-0259E5FB44F1@gmail.com> <54348.1337113582@turing-police.cc.vt.edu>
To: Valdis.Kletnieks@vt.edu
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 15, 2012, at 11:26 PM, Valdis.Kletnieks@vt.edu wrote:

> On Tue, 15 May 2012 14:35:53 +0300, Pantelis Antoniou said:
> 
>> Thermal management: How to distribute load to the processors in such
>> a way that the temperature of the die doesn't increase too much that
>> we have to either go to a lower OPP or shut down the core all-together.
>> This is in direct conflict with throughput since we'd have better performance
>> if we could keep the same warmed-up cpu going.
> 
> It's not just "temperature of the die".  When you have multiple aisles of 42U
> racks full of servers, you often hit "must keep average total BTU load per
> server below X" constraints.  There's plenty of colo's that are only using 40%
> of their floor space due to cooling constraints (you may be able to get the
> power company to pull another megawatt of copper into the building, but then
> you need to find someplace to put another megawatt worth of cooling).
> 

Interesting,

Never thought about that... 

-- Pantelis


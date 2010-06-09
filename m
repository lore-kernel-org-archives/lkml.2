Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab0FIVPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:15:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47141 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab0FIVP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:15:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UXFUSx3PW5yya8rgaNsIxzTlkFnzsbwIGsq74dmEwaO5QwQcMkb2zeMotdGEloYLXi
         6Jzd1mbXOAd9RSzsBo3NT4AQfGPHG6fFU02TZLgNDjkGE10q1VQk0ZAeUcXr0Qx7bz4B
         0cN5hfMo4Y0m6P822pIrCt2yNd7YVjc+mbjQA=
MIME-Version: 1.0
In-Reply-To: <1276107311.1745.66.camel@laptop>
References: <AANLkTin2pPqOUx--9fIX3BH3e-cU6oCRufijcx_4ozx5@mail.gmail.com>
	<20100608001929.GF2387@linux.vnet.ibm.com>
	<AANLkTikl13cJNuU32JzRarrUnoh5DYHr-Tbnv9B-UjsG@mail.gmail.com>
	<1275986441.5408.111.camel@twins>
	<AANLkTimXVlgzHivCQberLdrFP8BH_nJzt8_ozUNHG_aI@mail.gmail.com>
	<1276004075.2987.208.camel@twins>
	<AANLkTil6ucLZ0A6tWx-OQt_2EeKnx8nSx6rIg2t1L2t5@mail.gmail.com>
	<1276097068.1745.13.camel@laptop>
	<AANLkTinl2JKUX6859Ioa1y0DqHWXH5TrkissQ8BAF4cP@mail.gmail.com>
	<AANLkTilpM9O373rA0cw_wTYVfTiDPbjaKHScAGlt7IAr@mail.gmail.com>
	<1276106229.1745.65.camel@laptop>
	<1276107311.1745.66.camel@laptop>
Date: Wed, 9 Jun 2010 17:15:27 -0400
Message-ID: <AANLkTilG5bjN5QaOChmuVN6vT7kMK4eGaV-DvPynBn_t@mail.gmail.com>
Subject: Re: 2.6.35-rc2-git1 - include/linux/cgroup.h:534 invoked 
	rcu_dereference_check() without protection!
From: Miles Lane <miles.lane@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, Vivek Goyal <vgoyal@redhat.com>,
       Eric Paris <eparis@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       nauman@google.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 2:15 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-06-09 at 19:57 +0200, Peter Zijlstra wrote:
>> +       /*
>> +        * We're not in the pid-hash yet so no cgroup attach races, and the
>> +        * cgroup is pinned by the parent running this.
>> +        *
>> +        * Silence PROVE_RCU.
>> +        */
>
> Hum,.. not sure that's actually true though, the parent itself is still
> susceptible to races afaict..

Do you want what you sent earlier tested, or should I wait for another patch?

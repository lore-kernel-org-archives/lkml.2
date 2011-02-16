Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab1BPJBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 04:01:31 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39333 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab1BPJB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 04:01:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pw8v6VUdnB/qpoJWir9/gtjwqnTL4ec/wvlVymm2EKTdOqTttDcTWHF/NiJ9AkLRjx
         gZvoFGhw7YaVxEqNvrPwEpQHvCb3eebQ9kkO1EK47Q5E2tmxXOwofQBfXfd5sqjYCQxb
         kF8pxMyYooSYBTBfUCRre/2I1ktcOXNyJXMxg=
Date: Wed, 16 Feb 2011 10:01:23 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        shaohui.zheng@intel.com, rientjes@google.com, hpa@linux.intel.com
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk
 registration
Message-ID: <20110216090123.GE19830@htj.dyndns.org>
References: <AANLkTi=1xKqmedFqHPgDR32OrmNXg-T34NFo8qEnymfp@mail.gmail.com>
 <20110214182718.GB18742@htj.dyndns.org>
 <4D597D56.5060408@kernel.org>
 <20110214193050.GC18742@htj.dyndns.org>
 <4D5983EA.4020103@kernel.org>
 <20110215091103.GC3160@htj.dyndns.org>
 <20110215094327.GA1387@elte.hu>
 <20110215164920.GR3160@htj.dyndns.org>
 <20110216084105.GG16529@elte.hu>
 <20110216084852.GA17732@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216084852.GA17732@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 16, 2011 at 09:48:52AM +0100, Ingo Molnar wrote:
> I consolidated all these topics into the generic x86/mm tree which you could use as 
> a base.
> 
> I did not recognize the level of conflicts until i tried to pull your tree. You can 
> generally test such interactions with other bits of the x86 tree by test-merging 
> your pending work to tip:master.

Alright, I'll just rebase it on top of x86/mm and send a proper pull
request.

Thanks.

-- 
tejun

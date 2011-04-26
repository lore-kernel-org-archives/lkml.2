Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985Ab1DZDFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 23:05:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47360 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1DZDFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 23:05:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=W61x3KaRggB5HtPDD1DR5RWP61bXFq5R88Hmnp0Xtft1AhHkc03Q47cBUVD34YPGGy
         t0LbYsuzQMwadRJACt7WWrCV6jBMVgCeFXs5BNm3g/AvpH5zPtkcEnMYC8eFHWuQ6sbu
         UPYEYh6B+EmbBVF8RibgMoU0n7NI1smxyQDkQ=
MIME-Version: 1.0
In-Reply-To: <20110426115902.F374.A69D9226@jp.fujitsu.com>
References: <20110426025429.GA11812@darkstar>
	<20110426115902.F374.A69D9226@jp.fujitsu.com>
Date: Tue, 26 Apr 2011 11:05:20 +0800
Message-ID: <BANLkTimpidn07YRmm0gNDice3xo-tC8kow@mail.gmail.com>
Subject: Re: [PATCH] use oom_killer_disabled in all oom pathes
From: Dave Young <hidave.darkstar@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 10:57 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> oom_killer_disable should be a global switch, also fit for oom paths
>> other than __alloc_pages_slowpath
>>
>> Here add it to mem_cgroup_handle_oom and pagefault_out_of_memory as well.
>
> Can you please explain more? Why should? Now oom_killer_disabled is used
> only hibernation path. so, Why pagefault and memcg allocation will be happen?

Indeed I'm using it in virtio balloon test, oom killer triggered when
memory pressure is high.

literally oom_killer_disabled scope should be global, isn't it?

-- 
Regards
dave

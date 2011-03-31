Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1CaUZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 16:25:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44844 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1CaUZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 16:25:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZkAHfIcDPWDv9AY1GsOfd+0L7FdicS+AhCL3nsgKUNTEWtPGgyvuvyBZCqU1/mJtOH
         F1qBQ+0YI77vMF9XXwpX5lcNJMxzRtY2BVfNSEncZpUwBaS+LJMNPhuxZim0PjDId+jh
         0nBfimD7109/ln4BGIVj0YEBETNT5KBLgHyoE=
Message-ID: <4D94E33E.6030108@openvz.org>
Date: Fri, 01 Apr 2011 00:25:34 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Dongdong Deng <libfetion@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        KGDB Mailing List <Kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCH -tip] kgdb, x86: Pull up NMI notifier handler priority
References: <4D8A58E1.5090509@openvz.org>	<AANLkTimU3Hw5ZSo86Fv4RUtNPtS3kZBoWm4kh4MQaymu@mail.gmail.com> <AANLkTim_EDeYGu6_rsSh_3zDTW7mN5+Gwsb0t4HjKx6o@mail.gmail.com> <4D94BC9D.3040009@windriver.com>
In-Reply-To: <4D94BC9D.3040009@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 09:40 PM, Jason Wessel wrote:
...
> The net result. I'll sign-off on the kgdb change and add a TODO item to wait for the jump patching to enter the kernel.
> 
> Cyrill, I am assuming this is something we want to aim to merge into the 2.6.39 as a regression fix? 
> I'll try to get a version of Deng Dongdong's patch into linux-next as soon as possible in the mean time.
> 
> Cheers,
> Jason.

 Hi Jason, I think Deng Dongdong's patch is a good candidate for a while. Though Don mention another issue
on his Celerone machine so I need to think about the reason for unknown NMIs he observes. I try to get access
to p4 machine tomorrow and test some ideas. Will keep you in touch! (initially I thought to write a long post
about possible hang scenarios but then found they all are crap and I better to check details on real p4 machine
before claiming anything :).

-- 
    Cyrill

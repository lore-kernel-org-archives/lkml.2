Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1FNCtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 22:49:35 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:56617 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1FNCtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 22:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gtHLJArjcUSTqYtfsDgCSjvyCzCnGPTRIsSxucvW3RNQMlfQAeSXwxNnYk0X0MMaFm
         reenB6fyShJRUqlWHp2saAzj01Nge+u3ZAqpIQU9mrHwqg0ynmIsvWTh5m8ljr2baZKD
         kGwm9X1EesOyoU0BZo+Yl87ltTRE9S92490u4=
Message-ID: <4DF6CBDE.2070208@gmail.com>
Date: Tue, 14 Jun 2011 10:47:58 +0800
From: Asias He <asias.hejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 6/7] KVM-GST: adjust scheduler cpu power
References: <1308007897-17013-1-git-send-email-glommer@redhat.com> <1308007897-17013-7-git-send-email-glommer@redhat.com>
In-Reply-To: <1308007897-17013-7-git-send-email-glommer@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2011 07:31 AM, Glauber Costa wrote:
> This is a first proposal for using steal time information
> to influence the scheduler. There are a lot of optimizations
> and fine grained adjustments to be done, but it is working reasonably
> so far for me (mostly)
> 
> With this patch (and some host pinnings to demonstrate the situation),
> two vcpus with very different steal time (Say 80 % vs 1 %) will not get
> an even distribution of processes. This is a situation that can naturally
> arise, specially in overcommited scenarios. Previosly, the guest scheduler
> would wrongly think that all cpus have the same ability to run processes,
> lowering the overall throughput.

One typo in the commit log:

s/Previosly/Previously

-- 
Best Regards,
Asias He

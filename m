Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0LPHi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 02:38:56 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53279 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab0LPHiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 02:38:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L/6zwybM6dCnZkfgMEOR+KKYhqLlDQLPWLZZf5u/xjt80nFW1IhhwEYL6PvY535EB7
         8f+r2AjU1Sf225EPNmIT/HQm1WuAJrslhFm8BImxPQ4PJzFxM2I8jlN/BDeVnCJBMdai
         DFFJOf+2TDOWSxZoG1R8fO2QOKg+ed7PRhCHs=
Date: Thu, 16 Dec 2010 15:38:40 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Mariusz Kozlowski <mk@lab.zgora.pl>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rculist: fix borked __list_for_each_rcu() macro
Message-ID: <20101216073840.GA5313@cr0.nay.redhat.com>
References: <1292451072-5095-1-git-send-email-mk@lab.zgora.pl>
 <20101215232005.GB6595@linux.vnet.ibm.com>
 <20101216060236.GB4826@mako-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101216060236.GB4826@mako-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 07:02:36AM +0100, Mariusz Kozlowski wrote:
>On Wed, Dec 15, 2010 at 03:20:05PM -0800, Paul E. McKenney wrote:
>> On Wed, Dec 15, 2010 at 11:11:12PM +0100, Mariusz Kozlowski wrote:
>> > This restores parentheses blance.
>> 
>> Good catch, queued!!!
>> 
>> This does not actually appear to be in use anywhere in the kernel any
>> more, so I queued this for 2.6.38 rather than in the 2.6.37 urgent queue.
>> So, just out of curiosity, how did you find this one?
>
>Some years ago I wrote a dumb script that walks trees of () and {}.
>It catches unbalanced trees. It's dumb enough to fail with #ifdef etc,
>but most of the time it does its job. It reaches unreachable code
>and unused one too.
>

gcc will complain about this, however, in this case, it is used.

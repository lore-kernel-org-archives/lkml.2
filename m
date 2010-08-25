Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab0HYHB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 03:01:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54157 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab0HYHB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 03:01:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TUlS+KdZZGKzPEFd/agLNl3/03Y+w88B/xE13gRSsViI/Gv/j4eLyysVO0Xa+0s0bl
         f1gNUp4Z2s/ozjXRak3GKQpB7jbWfbZkVf+UvDI0YZHKFy5Rxuh2PsojJi2Wb342YuCQ
         uV/Z6xLzkAfgElLV/0VvgWl2tQOKiF+t4uKrM=
MIME-Version: 1.0
In-Reply-To: <20100824234132.a0f1cec3.akpm@linux-foundation.org>
References: <1281974138-5553-1-git-send-email-shijie8@gmail.com>
	<20100824164622.a3b2c1ed.akpm@linux-foundation.org>
	<AANLkTikSPB+8R4E7rsoVS2GN9ysROAPzKsLHqgMyP_yM@mail.gmail.com>
	<20100824234132.a0f1cec3.akpm@linux-foundation.org>
Date: Wed, 25 Aug 2010 15:01:56 +0800
Message-ID: <AANLkTikaBiptt+nF3A0cCsy7dKTZN+nAKHFT=MkE_TrF@mail.gmail.com>
Subject: Re: [PATCH] avoiding the same resource to be inserted
From: Huang Shijie <shijie8@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 2:41 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 25 Aug 2010 13:03:55 +0800 Huang Shijie <shijie8@gmail.com> wrote:
>
>> On Wed, Aug 25, 2010 at 7:46 AM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>
>> I think WARN_ON() is not power enough. If the CONFIG_BUG is not
>> defined, the warning message may not be printed. So I think using a
>> directly printk() here is better.
>
> No, WARN_ON() is good.  It gives us a backtrace and identifies the
> buggy code.  Only maniacs turn off CONFIG_BUG.
>

got it. Thanks a lot.

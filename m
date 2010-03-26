Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab0CZAfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 20:35:23 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34018 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab0CZAfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 20:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uxKypRvcE4yT7TpfB77+dYEeLJnsoNym0Wm4FE+lxuYZqffSpLZ2NEGQmhzovackWg
         ARq4TtctUm/H/thSHdZ66uYaSr/VcNy0ssU5cqsDKG9XQs8D21I95eHXzY5oq4jzM+Hm
         v2lk34xN09Ct7YKOUQUuCN6TH8E+le/hDZ+SE=
MIME-Version: 1.0
In-Reply-To: <1269542656.9188.37.camel@debian>
References: <1269542656.9188.37.camel@debian>
Date: Thu, 25 Mar 2010 17:35:21 -0700
X-Google-Sender-Auth: da85631ab12f5878
Message-ID: <e9c3a7c21003251735y278a24cagd50474ecaaaab55e@mail.gmail.com>
Subject: Re: [PATCH 0/2] mfd, dma: Add timb-dma driver
From: Dan Williams <dan.j.williams@intel.com>
To: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 11:44 AM, Richard Röjfors
<richard.rojfors@pelagicore.com> wrote:
> To follow are two patches.
>
> Samuel and Dan, since the MFD patch relies on the DMA patch.
> The MFD patch is against Samuels next tree, maybe it is easiest
> if the DMA driver is merged via Samuels tree?

It depends on the mfd patch at runtime, but thankfully not at build
time.  There are some other patches being floated by Linus to change
the device_terminate_all() and device_is_tx_complete() operations.
So, I want to take just the driver patch through the dma tree to make
sure everything stays in sync.

Thanks,
Dan

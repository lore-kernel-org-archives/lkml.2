Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab0FZNQv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 09:16:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab0FZNQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 09:16:49 -0400
Message-ID: <4C25FDA0.2020800@redhat.com>
Date: Sat, 26 Jun 2010 10:16:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PATCHES FOR 2.6.36] gspca for_2.6.36
References: <20100605133328.4c1089f2@tele>	<4C201089.20008@redhat.com> <20100622104210.5eee4849@tele>
In-Reply-To: <20100622104210.5eee4849@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 22-06-2010 05:42, Jean-Francois Moine escreveu:
> On Mon, 21 Jun 2010 22:23:21 -0300

>> I'm applying the remaining patches. If you think that this patch is
>> correct, please re-send it to both LMML and LKML, c/c the authors of
>> the slab.h removal, in order to get their acks, or, otherwise, please
>> re-submit it for 2.6.37 window.
> 
> Hi Mauro,
> 
> The slab.h dependency was changed in the kernel 2.6.34 and its
> inclusion in some gspca source files was needed in case of the usage of
> kmalloc/kfree only.
> 
> After removing the JPEG header allocation, most gspca subdrivers do not
> use alloc/free anymore, so, there is no need to include slab.h anymore.
> 
> On the other side, this patch is easily checked because, if wrong, it
> raises compilation errors on any architecture.
> 
> Then, both patches (removal of JPEG alloc/free and slab.h inclusion)
> should go to 2.6.36.

OK, makes sense. I'll apply the patch at staging/gspca.

Cheers,
Mauro.


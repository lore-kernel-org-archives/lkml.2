Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab0FSM34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 08:29:56 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57308 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab0FSM3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 08:29:54 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Jun 2010 08:29:54 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=maz7wCNFIDaR5nfyJ5atc427pqKM9gr10qbm3GuK0QKPr66SY8Jm4K0Ug3FA8oECy+
         svk2pXAsu5xeKXT6E+T+4KY6y/mGiYkfGx4IxcTaZnTaBzjdMaEU2mdeeD+4HuXX9CfX
         0e5Xbw+JBm29QEYh95uqeF3MqLq9Hqmm/yPr8=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20100619085849.GD18946@basil.fritz.box>
References: <AANLkTinX4TlNfvwrCtjfkU-bar3URnpvmPJB-sOi-9aT@mail.gmail.com> 
	<20100619085849.GD18946@basil.fritz.box>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Sat, 19 Jun 2010 14:22:33 +0200
Message-ID: <AANLkTikNEECT9CgPuCKy0h1LVKfjdXM-lavzW-TnUTz-@mail.gmail.com>
Subject: Re: man-pages text for MAV_MERGEABLE and MADV_UNMERGEABLE
To: Andi Kleen <andi@firstfloor.org>
Cc: hugh.dickins@tiscali.co.uk, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Sat, Jun 19, 2010 at 10:58 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> +.IR len .
>> +The KSM daemon
>> +.RI ( ksmd )
>
> You should probably make clear it's a kernel thread, not a classic
> daemon.

Thanks. I changed it to "KSM kernel thread"

>> +periodically scans those areas of user memory that have
>> +been marked as mergeable,
>> +looking for pages with identical content.
>
> Overall it seems like an internal implementation detail.

Not sure how I could improve this. Did you have some specific idea in mind?

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/

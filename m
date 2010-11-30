Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab0K3RvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:51:00 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61881 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab0K3Ru7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:50:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IIi9ne8iewHmZ2C8a5vr1nOFIaw9j30nnIZY3wntzcTNU3ALwse2hTZkEfsaQq9Lk/
         hz8jkfBOHsqzJMRQyJbG1fifvLCiV3w+/wpLUdbDnwSsh5zgwKNdNDnLVlGfiMtneC5m
         VkNQSuwgM3YEK6eDDA3RU6SOSLV5sovo6kL2c=
Subject: Re: When was ASLR introduced in the Linux kernel?
From: Victor van der Veen <vvdveen@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1291119324.2904.51.camel@edumazet-laptop>
References: <1291117660.3206.11.camel@D430>
	 <1291119324.2904.51.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 18:50:57 +0100
Message-ID: <1291139457.2701.14.camel@GX620>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > - When was ASLR introduced in the Linux kernel (not PaX/ExecShield)? 
> > - When was ASLR enabled by default? 
> > - What's the current state of ASLR in the Linux kernel? Is it still
> > under development? Or should we rely on the PaX/ExecShield patches?
> 
> randomize-va-space:
> 
> echo  val >/proc/sys/kernel/randomize_va_space
> 
> 
> vi +391 Documentation/sysctl/kernel.txt
> 
>  <snip>

Thanks, but this was not what I was really looking for. However,
searching for 'randomize_va_space' led me to a thread on lkml started by
Arjan van de Ven on January 27th, 2005:
http://lkml.org/lkml/2005/1/27/56

It would be great if someone can provide more details on this subject:
  1) when was randomize_va_space introduced? (probably somewhere in
2.6.11.x)
  2) when was it enabled by default (2.6.12.? but no announcement in
changelog?)
  3) which additions were added in later releases? (and when?)

Thanks,
Victor



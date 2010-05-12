Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab0ELO1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:27:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60437 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab0ELO1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=R2CoUT0CHOGjkhnyTlvsOPIGE3C/vWNSUjweqMYrsVLbfsRRou+iNOSOJCteQOayJc
         zsVhvg80GdQV4Ud4LfslEnMp+jHMnXPQRr2GQv325xYk2xM9z40XctgidlHv6mbjInEi
         SnYgtMkTGkGYZlNpBppa1FHP0mfj2i2dPy8dM=
MIME-Version: 1.0
In-Reply-To: <1273674048.1626.117.camel@laptop>
References: <eJjRf-6YM-1@gated-at.bofh.it> <eJktY-7JG-7@gated-at.bofh.it>
	 <eJktY-7JG-5@gated-at.bofh.it> <4BEAB6FC.8090105@intcomgrp.com>
	 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
	 <1273674048.1626.117.camel@laptop>
Date: Wed, 12 May 2010 16:22:27 +0200
Message-ID: <AANLkTil94_Wxd4TrpoJGi7gNqedd0CQRLJLvHiXYBRPG@mail.gmail.com>
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       menage@google.com, balbir@linux.vnet.ibm.com, lennart@poettering.net,
       jsafrane@redhat.com, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 4:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-05-12 at 16:13 +0200, Dhaval Giani wrote:
>> What you are saying is that an application
>> programmer who wants to just use memory cgroups should also care about
>> cpusets and just about countless other cgroup subsystems that can
>> exist.
>
> That's exactly what he says if he mounts them together.
>

No. That's not under his control.

Dhaval

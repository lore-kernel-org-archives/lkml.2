Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab0LNRxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:53:07 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33810 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab0LNRxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:53:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oE2e9mDGGhpuAPX3kRnQzV4U9ebnCg8zYpfL+k4/LCKo2q7ZtFrw668+BAcCvZE6cy
         st+dE8oFXWJCX1PQ9o/BY3NVPiz7LLoQXypreAYkxKZSchVY5AFnIIbvgBumfG8sj2eZ
         krIfhms8depV/gDCopj95SCiwbuHHmpwzQb2E=
Message-ID: <4D07AE34.9000602@gmail.com>
Date: Tue, 14 Dec 2010 18:49:40 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] persistent store (version 3) (part 1 of 2)
References: <AANLkTin2Z5XXf-3Gkqj72+FT4rM+hpqehK8Ys=gg++c9@mail.gmail.com>	<987664A83D2D224EAE907B061CE93D530193BBAA27@orsmsx505.amr.corp.intel.com>	<AANLkTi=NKa6UCeYsE0Y5iWnq8XYbVtSU7XiKJSNc5tLz@mail.gmail.com> <AANLkTin98z8_Maa8iJfbzyjtRDLkTve7PShPAvdukqZd@mail.gmail.com>
In-Reply-To: <AANLkTin98z8_Maa8iJfbzyjtRDLkTve7PShPAvdukqZd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/12/2010 18:00, Tony Luck ha scritto:
> On Tue, Dec 14, 2010 at 12:35 AM, Marco Stornelli
> <marco.stornelli@gmail.com> wrote:
>> I saw (very quickly) in drivers/staging/dream/pmem.c
> 
> Most recent commit for that says:
> 
>     Staging: dream: remove dream driver and arch from tree
> 
>     This code is stalled, with no one working on it anymore, and the main
>     msm code is now going through the proper channels to get merged
>     correctly.
> 
>     So remove it as it contains a number of kernel information leaks and it
>     is doubtful if it even still builds anymore.
> 
> :-(
> 
> -Tony
> 

Yeah, maybe it wasn't really ready for mainline :) However the idea
behind it, it was the same more or less, to have a piece of memory to
write some persistent information.

Marco

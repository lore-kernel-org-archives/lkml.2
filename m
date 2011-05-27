Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab1E0HWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 03:22:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35807 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1E0HWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 03:22:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=qXCDKMH+rV+j1dXxim0QVOS4DEk//vT2GD/t1rvBCzEbn+aKdkkcEBPc8sXFgjgrnH
         vCmSEAVmKir7AvYOE7P3V8yeiv8nnbTSAexGGO7breVUO/0Q98vMUm8HDT+bKDxTyh46
         dd2D77OYhtRdRmvNYvH7IN6jzJFPzr4u7yUKE=
MIME-Version: 1.0
In-Reply-To: <20110526193110.GA27504@srcf.ucam.org>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard>
 <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com>
 <20110526193110.GA27504@srcf.ucam.org>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Fri, 27 May 2011 09:22:12 +0200
Message-ID: <BANLkTin4dKQvSa00DsBHUj0z8rOrRXkBfQ@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Oliver Neukum <oneukum@suse.de>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tytso@mit.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 9:31 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, May 26, 2011 at 09:01:49AM +0200, D. Jansen wrote:
>
>> Exactly. 0.5 Watts is a lot of energy on a modern system. And on some
>> systems with proper link power management in sata and pcie it will be
>> even higher (~1 Watt I think). Think not only of the work that will be
>> lost if the system crashes (unlikely), but also of the work that could
>> never be done because the battery was gone (a certainty).
>
> I don't think link power management is relevant. The hysteresis there is
> sufficiently low that it's only going to make a difference during the
> point where you're actually throwing data across the link.
>
Ok, thanks! I'm not sure how much power could be saved in that case on
different system.
All I know is that it's about 0.5 Watts on my system. All I want is to
help people to be able to take advantage of that extra bit to have
extra battery (in my case 10-20%) for last bit of <insert activity>,
in my case taking notes.

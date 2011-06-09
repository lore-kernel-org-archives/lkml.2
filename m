Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab1FILo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:44:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37114 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1FILoz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:44:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vleFhsNCL7SDuyOFOu8KPIVKudBYwjC+1bU2TCkH8rTx/CHIrBd6zpvxUMKffFpIap
         OuaGPgoZ3NuF2Sg+IygHdr21HYISz8OssqsJKzv4rFRJuIUN/HS8OXTWJqgRLgFhITx8
         8VZv7pvBtynIHC0lEqJaE4QLtLjIb6pUaJHNY=
MIME-Version: 1.0
In-Reply-To: <20110609105220.GA3300@infradead.org>
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
	<20110609105220.GA3300@infradead.org>
Date: Thu, 9 Jun 2011 14:44:47 +0300
X-Google-Sender-Auth: 4gfkaKVO_uBx9ZpztyxVa1JLSPo
Message-ID: <BANLkTin8r-8bomDJp9EahO5Ckr+Amw8RtQ@mail.gmail.com>
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
From: "Amir G." <amir73il@users.sourceforge.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        linux-ext4@vger.kernel.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, sandeen@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 1:52 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jun 08, 2011 at 09:26:11PM +0300, Amir G. wrote:
>> In my old next3.sf.net wiki, which I do update from time to time,
>> I listed 4 advantages of Ext4 (then next3) snapshots over LVM:
>> * Performance: only small overhead to write performance with snapshots
>> * Scalability: no extra overhead per snapshot
>> * Maintenance: no need to pre-allocate disk space for snapshots
>> * Persistence: snapshots don't vanish when disk is full
>>
>> As far as I know, the only thing that has changed from dm-snap
>> to dm-multisnap is the Scalability.
>
> I don't think you have looked at dm-multisnap at all, have you?

You are on to me. I never tried it out or looked at the patches.
I did read about the multisnap shared storage target, but didn't know
about the thinp target.

Funny, I talked with Alasdair on LSF and asked him about the status
of multisnap and he only said there have been several implementations,
but didn't mention the thin provisioning target... or maybe I
understood him wrong.

So I guess that addresses the Maintenance and Persistence issues.
I'm sure it cannot thin provision the entire space for fs and snapsots
like ext4 snapshots do, but I'll have to read about it some more.
With regards to Performance, I will just have to run benchmarks, won't I ;-)

> It addresses all your points and many more.  Take a look at the code which
> is in the multisnap branch of https://github.com/jthornber/linux-2.6/,
> there's also some slides on it from Linuxtag at:
>
> https://github.com/jthornber/storage-papers/blob/master/thinp-snapshots-2011/thinp-and-multisnap.otp?raw=true
>

Thanks for the pointers!
These didn't come up in my googling.

Amir.

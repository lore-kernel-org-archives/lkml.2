Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab0CYHoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 03:44:38 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:53484 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab0CYHoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 03:44:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=o+M3LMhDB3J2EKXjMyqpazsvpQWyF524MMjvsE925Z1J6JjVfpXazP/3lKlYDAyRnS
         oZJhyRDM1JQk1lsyPreVB1IoXmmrON3VQAtoNoo3DsXlIzrovMtdEArR5XRsj2MaSZys
         dRzST+QUqS9Ic2FeogLj3iG5rwYd0hPbcnm1o=
MIME-Version: 1.0
In-Reply-To: <84144f021003242352g427ed93ay29e1c4b7e43b75cc@mail.gmail.com>
References: <alpine.DEB.2.00.1003250331460.5810@skynet.skynet.ie>
	 <84144f021003242352g427ed93ay29e1c4b7e43b75cc@mail.gmail.com>
Date: Thu, 25 Mar 2010 17:44:36 +1000
Message-ID: <21d7e9971003250044i3c2b3fd1v82a56b56c24db3a3@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 4:52 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Dave,
>
> 2010/3/25 Dave Airlie <airlied@linux.ie>:
>> Some nouveau updates + misc drm core fixes,
>>
>> radeon kms: mostly fixes, however a cleanup to the ugly asic tables to
>> avoid drift between C prototypes moves some stuff around, and I've merged
>> Jerome's GPU recovery code, as I'd much rather users had some of hope of
>> recovering from their GPU locking up than a dead box. It seems to work
>> for quite a lot of people that have tested it, and it won't make a GPU
>> lockup problem worse. This also finally fixes HDMI audio on rv7xx cards.
>
> Are there any i915 fixes pending? I tried 2.6.34-rc2 few days ago and
> all I got was a blank screen at start up. The driver is pretty busted
> for 2.6.33 also, I'm getting random screen corruption and the
> occasional blank screen (which is "fixed" by suspend/resume).
>
> I'm unfortunately busy with working on something else so I don't have
> time right now to debug the thing. Just wanted to know if you're aware
> of the quality problems with i915 and if there are any fixes pending.

I leave i915 up to Eric after -rc1, we found it hard to sync our
schedules before,

I'm sure he has some stuff in his tree.

Dave.

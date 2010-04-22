Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0DVOd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 10:33:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53236 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab0DVOd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 10:33:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jZN1Hj0a/AgNK4BAd6xFg+V6toTnDBqLq9DCydmi5t9+8sBdo/8508mBu6n7ZceK08
         +agsA/tQ//Q7+hVF1Jl6DGAhlFwmZO5rC3Mr3+4U4FbgD1LcrFDdAzpwd9rp4ospZKHo
         2moo95fppnK0B1Q6rhAmSzbJN7hsc3XVM483Y=
MIME-Version: 1.0
In-Reply-To: <20100401190205.GD6027@erda.amd.com>
References: <20100401011725.GA27567@basil.fritz.box>
	 <20100401190205.GD6027@erda.amd.com>
Date: Thu, 22 Apr 2010 10:33:56 -0400
Message-ID: <m2h5e61b72f1004220733n65451418p7c321f07eb5d6b58@mail.gmail.com>
Subject: Re: [PATCH] oprofile: remove double ring buffering
From: John Villalovos <sodarock@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 3:02 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 01.04.10 03:17:25, Andi Kleen wrote:
>> Got confirmation now this patch fixes most of the dropped oprofile
>> samples problem on a particular intensive test on a large system.
>> So now submitting the previous RFC formally.
>> .34 / Stable candidate.
>
> Thanks Andi, will take a look at this next week.

I was wondering what the state of this patch is.  I don't see it in
linux-2.6 or linux-next. or in
git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git

Thanks,
John

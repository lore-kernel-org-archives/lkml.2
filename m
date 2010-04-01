Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0DAHnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:43:46 -0400
Received: from mail-iw0-f202.google.com ([209.85.223.202]:55560 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0DAHnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IoOtlFPdKC/2YRs60J1T19Fyutya5o8VgUlFGqcOwE9S03KeW1JlaF7CSrbHQxXaZj
         U8oY5TTx284/TleIr0fp0DLDzSyvwWMOyI9tN/T5pZDa5yy2Vis7T4f2715liZsKtGcZ
         iECn7yTcqBlE91tyeFWCxx3lrtaERgSQd9yR8=
MIME-Version: 1.0
In-Reply-To: <i2tb170af451003312236m27fbe450k6c3b955808f13247@mail.gmail.com>
References: <alpine.DEB.2.00.1003300530150.5127@skynet.skynet.ie>
	 <21d7e9971003300007re486f22jbd2e98fcc104ac92@mail.gmail.com>
	 <i2tb170af451003312236m27fbe450k6c3b955808f13247@mail.gmail.com>
Date: Thu, 1 Apr 2010 17:43:39 +1000
Message-ID: <k2i21d7e9971004010043n6bbf8f0fv7bf2f9f2233e195d@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/1 Rafa³ Mi³ecki <zajec5@gmail.com>:
> W dniu 30 marca 2010 09:07 u¿ytkownik Dave Airlie <airlied@gmail.com> napisa³:
>> 2010/3/30 Dave Airlie <airlied@linux.ie>:
>>>
>>> [re-pull request]
>>
>> Actually Linus, don't bother, consider this revoked, I'm going to kill
>> the GPU reset code
>> and re-send this tomorrow, its just a mess to get it back out of the
>> tree at this point,
>
> Ping? Are you waiting for Jerome or something? Please do not stop
> pulling whole stuff because Jerome is preparing some patch for last
> moment.
>
> I believe I'll be much better to pull most stuff ASAP to let ppl test
> it, and later eventually ask Linus to get some one-two additional
> small patches.

Rebasing out Jerome's patches and reverifying stuff works isn't
something that takes 5 minutes. Since the rebase pretty much
negates all the testing I'd done.

Dave.

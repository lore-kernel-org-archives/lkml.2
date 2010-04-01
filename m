Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab0DAHp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:45:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52265 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab0DAHpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:45:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kQ3LXQw8NqNPJATSy0RJKM5zxXcnAUdNsgeD7UXiN0ADmcMUMEephnIJBMjU6GYiVK
         snbdqtH9/j9fPtC6WIBpTPdyIeFNDEMwRdREsrc4Z4rJ79frt0Zb8VpWClIu60tk2W0Y
         RLmMqVOwUxJOA3iu1cwkF9rKLL6KZY/aeT6/E=
MIME-Version: 1.0
In-Reply-To: <k2i21d7e9971004010043n6bbf8f0fv7bf2f9f2233e195d@mail.gmail.com>
References: <alpine.DEB.2.00.1003300530150.5127@skynet.skynet.ie>
	 <21d7e9971003300007re486f22jbd2e98fcc104ac92@mail.gmail.com>
	 <i2tb170af451003312236m27fbe450k6c3b955808f13247@mail.gmail.com>
	 <k2i21d7e9971004010043n6bbf8f0fv7bf2f9f2233e195d@mail.gmail.com>
Date: Thu, 1 Apr 2010 09:45:15 +0200
Message-ID: <w2zb170af451004010045td510730pe59e85c0c6476f8a@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 1 kwietnia 2010 09:43 użytkownik Dave Airlie <airlied@gmail.com> napisał:
> 2010/4/1 Rafał Miłecki <zajec5@gmail.com>:
>> W dniu 30 marca 2010 09:07 użytkownik Dave Airlie <airlied@gmail.com> napisał:
>>> 2010/3/30 Dave Airlie <airlied@linux.ie>:
>>>>
>>>> [re-pull request]
>>>
>>> Actually Linus, don't bother, consider this revoked, I'm going to kill
>>> the GPU reset code
>>> and re-send this tomorrow, its just a mess to get it back out of the
>>> tree at this point,
>>
>> Ping? Are you waiting for Jerome or something? Please do not stop
>> pulling whole stuff because Jerome is preparing some patch for last
>> moment.
>>
>> I believe I'll be much better to pull most stuff ASAP to let ppl test
>> it, and later eventually ask Linus to get some one-two additional
>> small patches.
>
> Rebasing out Jerome's patches and reverifying stuff works isn't
> something that takes 5 minutes. Since the rebase pretty much
> negates all the testing I'd done.

Oh, OK. Thanks for your work on getting 2.6.34 into nice shape :)

-- 
Rafał

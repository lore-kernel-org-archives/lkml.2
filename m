Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab1BZPW4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 10:22:56 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45039 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab1BZPWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 10:22:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=WS7Mh4LQAp31y0yqMNkceXN0LV9SQl180dEco0BEuFr5jurmGu1j6ZkUKyoOtfeC0R
         jRI80G0c3sIkWTCrAOs4jgvQSoozsnQeIDHf0rlkGlNn1nbXuKv/LQdGZ3DqLVWxdUpe
         JZSK7mQo0RyyQ2GgB60FaYQADr9Lw2Z+JDydo=
Message-ID: <4D691ACA.9090405@gmail.com>
Date: Sat, 26 Feb 2011 16:22:50 +0100
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110208 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Taking forward the realtime work
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After digging through the -rt patchset again I wanted to take it forward 
to the current kernel, so far I didn't to get much work done as the code 
seems to be kinda invasive, even with a lot of the things already in 
mainline. However a lot of things in the -rt patch seem to no longer be 
needed, since softirqs are merged, the BKL is gone, and there's a patch 
set out to make mm preemptible.

I've started testing from the mm-preempt patchset, and it seems to boot, 
but now that I'm actually looking at the -rt patchset diff from 
v2.6.33.7 it's not that trivial to port forward, so I'm looking for 
help. Blindly trying to apply the diff forward 6 versions will not work, 
so I'm looking at how to add the patches in such a way that each change 
is done in a logical order, in such a way preferably that at each point 
the kernel is bootable. I understand that for -rt there will be a few 
commits for which that won't be possible, but it seems to me the amount 
of work needed to get -rt working isn't as big any more as it used to be.

Note: There's no guarantee I'll be able to pull it off, but there's this 
itch I need to get rid of. ;)

Cheers,
Maarten

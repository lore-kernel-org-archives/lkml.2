Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2KVScz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:32:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33869 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2KVScx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:32:53 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20121122111825.GA7188@polaris.bitmath.org>
References: <CA+55aFxdin9yatcyRkTqG--fdBS-KHh0eXnK5RmONw_uJe8sfQ@mail.gmail.com>
	<20121120103905.GA3908@polaris.bitmath.org>
	<CAKMK7uEemJg=h3aY2xfTRaEqC9t5ADgS2-FSasAvdC66zbz1Vw@mail.gmail.com>
	<20121122111825.GA7188@polaris.bitmath.org>
Date: Thu, 22 Nov 2012 14:10:40 +0100
Message-ID: <CAKMK7uFr8jHALagnzJp26Sn-WMuj4VcMF0e+q0GKgyRbW0h-wg@mail.gmail.com>
Subject: Re: Linux 3.7-rc6
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Henrik Rydberg <rydberg@bitmath.se>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 12:18 PM, Henrik Rydberg <rydberg@bitmath.se> wrote:
>> My apologies for the long delay in answering, I've somehow mixed up
>> different bugreports and thought I've sent you a patch to test
>> already. Anyway, please test
>>
>> https://patchwork.kernel.org/patch/1728111/
>
>     Tested-by: Henrik Rydberg <rydberg@euromail.se>

Can you please boot with drm.debug=0xe added to your kernel cmdline
with that patch applied and attach the full dmesg?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

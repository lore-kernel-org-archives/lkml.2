Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab1IMXGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 19:06:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51883 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988Ab1IMXGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 19:06:07 -0400
Message-ID: <4E6FE1DA.6050705@gmail.com>
Date: Wed, 14 Sep 2011 02:06:02 +0300
From: Stratos Psomadakis <s.psomadakis@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org> <CA+55aFwEgp=3F6uH198XuQR0=6Um-Kp+0Wjcm0Xv1WoHRveKXw@mail.gmail.com> <20110913141158.GA7352@ucw.cz> <4E6F6A89.8020102@gmail.com> <20110913155023.GA21255@tassilo.jf.intel.com>
In-Reply-To: <20110913155023.GA21255@tassilo.jf.intel.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 06:50 PM, Andi Kleen wrote:
>> ketchup? [1]
> My patch won't fix ketchup. Obviously it cannot download 2.6.40
>
> -Andi
Well, since ketchup does not in any way rely on the kernel version
reported at 'runtime' (ie by uname), your patch doesn't actually affect
ketchup.

Anyway, I think that this discussion is a bit 'offtopic', since I didn't
think you had ketchup (or similar scripts) in mind for this patch.
I just replied to Pavel, just to let him (and anyone else interested)
know, that ketchup has in fact been updated to handle the newer kernel
versions.

Thanks,

-- 
Stratos Psomadakis
<s.psomadakis@gmail.com>


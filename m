Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab2DDIaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 04:30:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48371 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab2DDIaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 04:30:11 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1204041050200.26551@math.ut.ee>
References: <alpine.SOC.1.00.1204041000040.26551@math.ut.ee>
	<CAPM=9twGWHgQU01mj0=Y2iOe1Oo2za4QLY-DkEyYCRVd60+iTg@mail.gmail.com>
	<CAPM=9tx4jJLRzfBjePYWLQh5Ff6t6DGu3fSMxv7eENneokDsrQ@mail.gmail.com>
	<alpine.SOC.1.00.1204041050200.26551@math.ut.ee>
Date: Wed, 4 Apr 2012 09:30:11 +0100
Message-ID: <CAPM=9tzZUr=_iFHOGRVGOEK3NkpZCnLEb_HEEWU7vYK6aekDXw@mail.gmail.com>
Subject: Re: nouveau regression in 3.4-rc4-144
From: Dave Airlie <airlied@gmail.com>
To: Meelis Roos <mroos@linux.ee>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

please revert d06221c0617ab6d0bc41c4980cefdd9c8cc9a1c1

I'm off on holidays and it probably needs a bit more testing.

Dave.

On Wed, Apr 4, 2012 at 8:50 AM, Meelis Roos <mroos@linux.ee> wrote:
>> Please try reverting d06221c0617ab6d0bc41c4980cefdd9c8cc9a1c1
>>
>> If this works, can someone get it fixed or reverted, I'm off on
>> holidays, limited net.
>
> Yes, this fixes it.
>
> --
> Meelis Roos (mroos@linux.ee)

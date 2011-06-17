Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab1FQP3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:29:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45701 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab1FQP3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:29:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=kX0P/vvnd4KQpMgkPhlK2ijaYUV1HG+dDqVEBEo3DRVSmLA8aOj+E4eQNzrrrEs9ST
         21QFXAKACKSQYhpAZKi0ubQzf2/pf3ngh9u7mV1Oa8ye/ex58BpWgLNMMdwZcwEmZU8x
         CISPAfQn0yDEf2G0HNx89U0HgivRvJXDvRogQ=
MIME-Version: 1.0
In-Reply-To: <20110617071247.2f293938@jbarnes-desktop>
References: <1308070307-2630-1-git-send-email-daniel.blueman@gmail.com>
 <6E3BC7F7C9A4BF4286DD4C043110F30B568EC644CB@shsmsx502.ccr.corp.intel.com> <20110617071247.2f293938@jbarnes-desktop>
From: Robert Hooker <sarvatt@ubuntu.com>
Date: Fri, 17 Jun 2011 11:29:24 -0400
X-Google-Sender-Auth: jVVnhx-zcz2dfz4vJIk2QBc2cFk
Message-ID: <BANLkTikEL=v2VS-43SsPubiUORyWxx+pFw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 3.0-rc3] i915: Fix gen6 (SNB) GPU stalling
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Sun, Yi" <yi.sun@intel.com>, Daniel J Blueman <daniel.blueman@gmail.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Meng, Mengmeng" <mengmeng.meng@intel.com>,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/17 Jesse Barnes <jbarnes@virtuousgeek.org>:
> On Fri, 17 Jun 2011 15:52:58 +0800
> "Sun, Yi" <yi.sun@intel.com> wrote:
>
>> All,
>> Thank for Mengmeng’s testing work, now the status is as following:
>>
>> The bug33394(performance regression: screen stuttered when running the demo of 3D games with compiz enabled without GPU semaphores) is fixed. The two issue(stutter and hangcheck) is gone, now.
>> The issue described as bug 36407 isn’t able to be reproduced.
>> The bug 36653 is still there.
>
> Thanks for testing, looks like this is an important fix (36652 is what
> I think you mean on the last one?).
>
> --
> Jesse Barnes, Intel Open Source Technology Center
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx
>


This also fixes https://bugs.freedesktop.org/show_bug.cgi?id=36241
when applied to 2.6.38 and 2.6.39, it would be nice to see it cc:
stable.

Tested-by: Robert Hooker <robert.hooker@canonical.com>

Thanks!

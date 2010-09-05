Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0IEKVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 06:21:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42597 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0IEKVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 06:21:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=m4MbJJ6bhHISLujBwsQYI6oDUB8MDsQICo6fnO1Cw2rfiOWDdHpUbbOjAS2BlfdIMZ
         1HQK95NaxzNePb7OjZGUGNKF4+2vlkW/xQc9xqyDXEbwiofto4k0K1GcmjEuUwu2uY4k
         LI037/zLYawLIYteVBCPh1cF+hWkihu2TjfWQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=rcFZff22TMX+vfQj=5jQunmiC2UvEhZoheeTd@mail.gmail.com>
References: <1283588234-2514-1-git-send-email-penberg@kernel.org>
	<89k83a$9hv9li@azsmga001.ch.intel.com>
	<AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com>
	<alpine.LSU.2.00.1009041244440.3044@sister.anvils>
	<87vd6ls0jd.fsf@turtle.gmx.de>
	<20100904224453.GA31664@sucs.org>
	<AANLkTin63=Eyyk_dwmKtPvP_qPyKR2eDn-2FmmvGjTQu@mail.gmail.com>
	<20100905091451.GA23589@sucs.org>
	<AANLkTi=rcFZff22TMX+vfQj=5jQunmiC2UvEhZoheeTd@mail.gmail.com>
Date: Sun, 5 Sep 2010 12:21:33 +0200
Message-ID: <AANLkTimkv-DgWYfD8GOj1bsEvFJfY+-g06uz=WDC37PC@mail.gmail.com>
Subject: Re: [PATCH] Revert "drm/i915: fix vblank wait test condition"
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Sven Joachim <svenjoac@gmx.de>, Hugh Dickins <hughd@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, Sep 5, 2010 at 12:13 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> Hi.
>
>> Do you have any debugging options (e.g.
>> lock dep checking) on that would slow your kernel down and stop the
>> issue from ocurring?
>>
>
> Never had this kind of issues. I also tested rc2 without problems.
>

[root@ratbert] - [~] zgrep -i lock /proc/config.gz |grep -v ^#
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_LOCK_KERNEL=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_BLOCK=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_FILE_LOCKING=y

>> --
>> Sitsofe | http://sucs.org/~sits/
>>
>
> Regards,
> Fabio
>

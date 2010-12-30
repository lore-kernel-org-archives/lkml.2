Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0L3UKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 15:10:41 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59244 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab0L3UKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 15:10:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J7ZMOlNJsZOYC1AkIIJRG/a6LsxNK5re9/CpTdgaUmJ2WYvivWdLriQeyxEfJ/HIUF
         xtP7udXu18pcIQtdCmLEnUIIM5pbBrBPGhuo2DeiCs5VCVgcudndKO0d5ip7Q2rhXj0G
         w47RTsPFm33lnQJTWnhGExw+0WbLzaE0IWy2o=
MIME-Version: 1.0
In-Reply-To: <AANLkTik3M2msXQA2Q--r492Oohph9cD7=JYBWx=vNzg-@mail.gmail.com>
References: <20101229125129.d48fb6fc.sfr@canb.auug.org.au>
	<20101229023457.GA4206@core.coreip.homeip.net>
	<20101230105130.5d27a82b.sfr@canb.auug.org.au>
	<AANLkTik38TzE_L_m8KpG-PmWGPeHjC8FYU=reRN8L7E5@mail.gmail.com>
	<AANLkTik3M2msXQA2Q--r492Oohph9cD7=JYBWx=vNzg-@mail.gmail.com>
Date: Thu, 30 Dec 2010 12:10:38 -0800
Message-ID: <AANLkTi=icbrfOT_gvEwcLJO94wtuF8QF=aOx8z-LajeB@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (input
 tree related)
From: Ping Cheng <pinglinux@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 11:58 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Thu, Dec 30, 2010 at 19:06, Ping Cheng <pinglinux@gmail.com> wrote:
>> On Wed, Dec 29, 2010 at 3:51 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> On Tue, 28 Dec 2010 18:34:58 -0800 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
>>>> On Wed, Dec 29, 2010 at 12:51:29PM +1100, Stephen Rothwell wrote:
>>>> > After merging the final tree, today's linux-next build (powerpc
>>>> > allyesconfig) failed like this:
>>>> >
>>>> > drivers/input/touchscreen/wacom_w8001.c: In function 'w8001_setup':
>>>> > drivers/input/touchscreen/wacom_w8001.c:287: error: implicit declaration of function 'mdelay'
>>>> >
>>>> > Caused by commit b8fe15cb1b435928f9967d660e925fe7afb32787 ("Input:
>>>> > wacom_w8001 - support pen or touch only devices").  See Rule 1 in
>>>> > Documentation/SubmitChecklist.
>>
>> I do not see the error on my testing systems somehow. Does adding the
>> following line resolve the issue?
>>
>> #include < include/linux/delay.h>
>
> "#include <linux/delay.h>", I assume?

You are right. Take it as a typo or copy/paste error ;).

Ping

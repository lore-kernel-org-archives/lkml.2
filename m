Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757Ab2GDIET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:04:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61257 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933745Ab2GDIEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:04:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAMPhdO-goJK9JATj_pxbBhDFyN+ZFEHUd6PbRiMeb6RkU1OBmQ@mail.gmail.com>
References: <1341265214.1911.151.camel@x61.thuisdomein>
	<CAMPhdO-goJK9JATj_pxbBhDFyN+ZFEHUd6PbRiMeb6RkU1OBmQ@mail.gmail.com>
Date: Wed, 4 Jul 2012 16:04:02 +0800
Message-ID: <CAN1soZynjS8+0eq7pv=tkTcw4-52yvA-ygEmbKKY0b4LR2nQ0A@mail.gmail.com>
Subject: Re: [PATCH] ARM: mmp: remove mach/gpio-pxa.h
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 2:30 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Tue, Jul 3, 2012 at 5:40 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
>> Commit 157d2644cb0c1e71a18baaffca56d2b1d0ebf10f ("ARM: pxa: change gpio
>> to platform device") removed all includes of mach/gpio-pxa.h. It kept
>> this unused header in the tree. Using it can't work, as it itself
>> includes the non-existent header plat/gpio-pxa.h. This header can safely
>> be removed.
>>
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>
> Acked-by: Eric Miao <eric.y.miao@gmail.com>
>
Applied

Regards
Haojian

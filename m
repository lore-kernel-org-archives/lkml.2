Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1GZCT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 22:19:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:17460 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab1GZCTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 22:19:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:x-system-of-record;
	b=Dnl3NZ8Yo71skYychY24r3LvJyKxsHP/CpdHdh5zqs1IEACA8cLK7LpHTOTK5bfxU
	6H1mjkguuzfcOp5Co9uRA==
MIME-Version: 1.0
In-Reply-To: <20110725082752.GB22937@core.coreip.homeip.net>
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
 <1311169146-20066-2-git-send-email-djkurtz@chromium.org> <20110725082752.GB22937@core.coreip.homeip.net>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Tue, 26 Jul 2011 10:19:31 +0800
X-Google-Sender-Auth: HUI-PqWzCIZC_ledwNY6rt5CcLI
Message-ID: <CAGS+omB1sR88N=yytW7k_O8r4WkCowQwGFN30wzyK0wEEWBUmw@mail.gmail.com>
Subject: Re: [PATCH 1/9 v2] Input: synaptics - refactor y inversion
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: rydberg@euromail.se, chase.douglas@canonical.com, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 4:27 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Jul 20, 2011 at 09:38:58PM +0800, djkurtz@chromium.org wrote:
>> From: Daniel Kurtz <djkurtz@chromium.org>
>>
>> Synaptics touchpads report increasing y from bottom to top.
>> This is inverted from normal userspace "top of screen is 0" coordinates.
>> Thus, the kernel driver reports inverted y coordinates to userspace.
>>
>> This patch refactors this inversion.
>>
>
> I really do not see the point...

The point is that this inversion is done in 3 places in the driver.
Refactoring lets us document why this inversion is happening in just a
single place.

>
> Thanks.
>
> --
> Dmitry
>

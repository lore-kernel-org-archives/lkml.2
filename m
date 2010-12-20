Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0LTIha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 03:37:30 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33627 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab0LTIh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 03:37:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qSCBpLNXB/On4ufjeq4rbN4xogAWfW36pELsbipmtS9yZgLzWQun7qrWCUL/0ofHQk
         MZ0a6/Iyl64FTiw5fJROsbJXJ7NHMLFz+gJZtTPX2XXR7x4KoSe/qO2oJSnFW00KKPS3
         SemZ06/lkdhGd7dDrjpRZggXGqAu0nHo5dgz0=
MIME-Version: 1.0
In-Reply-To: <1292813544.22702.342.camel@Joe-Laptop>
References: <4D0DD027.4000507@gmail.com>
	<1292813544.22702.342.camel@Joe-Laptop>
Date: Mon, 20 Dec 2010 09:37:27 +0100
Message-ID: <AANLkTi=WP9k_yqyvvJmy2ZW0ErO9Yt=jQjVvWQ_RGByv@mail.gmail.com>
Subject: Re: [PATCH][RESEND] scripts: add no-warning option to the checkpatch script
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, apw@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/20 Joe Perches <joe@perches.com>:
> On Sun, 2010-12-19 at 10:28 +0100, Marco Stornelli wrote:
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>> Add no-warning option to the checkpatch script.
>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>
> Hello Marco.
>
> I don't have much of an opinion on this.
> I don't actually use checkpatch much.
> Why do you think it's useful?

To "debug" a patch from style point of view, I think it's useful to
fix before the errors and then the warnings. So this option it's
useful as a "filter". However, I added you in cc: because of a reply
to my first patch that indicated you as a person interested in this
scope.

Marco

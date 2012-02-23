Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab2BWTjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:39:45 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42571 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab2BWTjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:39:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bobbypowers@gmail.com designates 10.229.136.19 as permitted sender) smtp.mail=bobbypowers@gmail.com; dkim=pass header.i=bobbypowers@gmail.com
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1202231927240.24797@skynet.skynet.ie>
References: <1330023731-14043-1-git-send-email-bobbypowers@gmail.com>
	<alpine.DEB.2.00.1202231927240.24797@skynet.skynet.ie>
Date: Thu, 23 Feb 2012 14:39:43 -0500
Message-ID: <CAArOQ2Wi9qeS0vnFdm__Ow1fxApVG36O+DLZx2TLL6EOa+9GZA@mail.gmail.com>
Subject: Re: [PATCH] linux headers: include linux/types.h where appropriate
From: Bobby Powers <bobbypowers@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 2:28 PM, Dave Airlie <airlied@linux.ie> wrote:
>
>> This silences the related header check warnings.
>
> please fix the bug in the correct place, the drm.h header includes
> linux/types.h and this is one on purpose.
>
> maybe expend some effort fixing the stupid tool to recurse like a normal
> preprocessor would.

Hah fair enough, I'll look into that later today then.

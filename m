Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab2DMXEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 19:04:08 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56019 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756726Ab2DMXEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 19:04:07 -0400
MIME-Version: 1.0
In-Reply-To: <201204131552.03079.hartleys@visionengravers.com>
References: <201204131552.03079.hartleys@visionengravers.com>
Date: Sat, 14 Apr 2012 01:04:04 +0200
Message-ID: <CAFLxGvwFiGghttyPmSv0L_m7GEr0FdnN6pM9Zxzr9d_vt8ercA@mail.gmail.com>
Subject: Re: [PATCH] Documentation: remove 'linux' from dontdiff file
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 12:52 AM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> The linux entry in the dontdiff file causes the include/linux
> directory to be skipped.
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> CC: Randy Dunlap <rdunlap@xenotime.net>

NAK.

UserModeLinux generates the linux file.

-- 
Thanks,
//richard

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab2DMXJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 19:09:25 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48533 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755954Ab2DMXJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 19:09:23 -0400
MIME-Version: 1.0
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206986C0C6D@AUSP01VMBX24.collaborationhost.net>
References: <201204131552.03079.hartleys@visionengravers.com>
	<CAFLxGvwFiGghttyPmSv0L_m7GEr0FdnN6pM9Zxzr9d_vt8ercA@mail.gmail.com>
	<ADE657CA350FB648AAC2C43247A983F00206986C0C6D@AUSP01VMBX24.collaborationhost.net>
Date: Sat, 14 Apr 2012 01:09:22 +0200
Message-ID: <CAFLxGvwCEmr2JUe5UNYGoUAe_unb1iZvit=OFrMo=0=2ON0cGA@mail.gmail.com>
Subject: Re: [PATCH] Documentation: remove 'linux' from dontdiff file
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 1:06 AM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> Hmm.. So we are suppressing an entire branch of the directory tree (a
> fairly major one at that) for one file?
>

No, we need a better solution.
Your patch replaces a regression with another one...

-- 
Thanks,
//richard

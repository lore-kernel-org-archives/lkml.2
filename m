Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2HaN0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:26:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64754 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2HaN0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:26:14 -0400
MIME-Version: 1.0
In-Reply-To: <5040B80E.4070809@gmail.com>
References: <5040B80E.4070809@gmail.com>
Date: Fri, 31 Aug 2012 15:26:13 +0200
Message-ID: <CAFLxGvyt4s4cWHp7fRpNQi_o-1-4w02Zq+nrm+p945qHX9RUmQ@mail.gmail.com>
Subject: Re: [PATCH] um: fix compilation error
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 3:11 PM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> Fix a compilation error due to a regression of commit
> d3c1cfcdb43e023ab1b1c7a555cd9e929026500a
> "um: pass siginfo to guest process".
>
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>

Thanks, patch will be submitted to Linus ASAP with other UML fixes.

-- 
Thanks,
//richard

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab2DUMeY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 08:34:24 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59679 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666Ab2DUMeX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 08:34:23 -0400
MIME-Version: 1.0
In-Reply-To: <1335008543-13399-1-git-send-email-valentin.ilie@gmail.com>
References: <1335008543-13399-1-git-send-email-valentin.ilie@gmail.com>
Date: Sat, 21 Apr 2012 14:34:21 +0200
Message-ID: <CAFLxGvx+-P3SvLUPhZF5MW68Ss-9m59BfOY1SeqtjVtWaQk+qA@mail.gmail.com>
Subject: Re: [PATCH] kernel: sys.c: Fixed coding style issues
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Valentin Ilie <valentin.ilie@gmail.com>
Cc: akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 1:42 PM, Valentin Ilie <valentin.ilie@gmail.com> wrote:
> Fixed some minor coding style issues.
>
> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
> ---
>  kernel/sys.c |  526 +++++++++++++++++++++++++++++-----------------------------
>  1 file changed, 262 insertions(+), 264 deletions(-)
>

This kind of patch is not easy to review.
Can you please prove that no logic has changed?
E.g. By comparing the object file before and after your patch...

-- 
Thanks,
//richard

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab2FNVlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 17:41:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65515 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2FNVlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 17:41:49 -0400
MIME-Version: 1.0
In-Reply-To: <1339709115-531-1-git-send-email-per.forlin@stericsson.com>
References: <1339709115-531-1-git-send-email-per.forlin@stericsson.com>
Date: Thu, 14 Jun 2012 14:41:48 -0700
X-Google-Sender-Auth: -Ei8wxMB5JCbCOgmPxJ40Adk-DE
Message-ID: <CAGXu5jKqaddf3T+LMS-6VMgH98JbMG-NsjB8uajNw19R7OAfig@mail.gmail.com>
Subject: Re: [PATCH] reboot: disable nonboot CPUs
From: Kees Cook <keescook@chromium.org>
To: Per Forlin <per.forlin@stericsson.com>
Cc: linux-kernel@vger.kernel.org, gorcunov@openvz.org,
        serge.hallyn@canonical.com, Linus Walleij <linus.walleij@linaro.org>,
        Per Forlin <per.lkml@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 2:25 PM, Per Forlin <per.forlin@stericsson.com> wrote:
> Disable the nonboot CPUs to safely migrate tasks and interrupts
> to the boot CPU. This will prevent the nonboot CPUs to
> interfer or block the boot CPU from being able to reboot
> the system successfully.

Reviewed-by: Kees Cook <keescook@chromium.org>

This seems reasonable to me, though I haven't looked too deeply at the
reboot path.

-Kees

-- 
Kees Cook
Chrome OS Security

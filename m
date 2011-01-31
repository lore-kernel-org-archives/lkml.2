Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1AaGRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 01:17:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46533 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1AaGRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 01:17:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=fQLF9syjwrvXc0wF7tTcphpLGy0AJLseepsLbzGEW5gLY/GDu+dPygW96pQX5xc1Ie
         XjjCrMGLqhwIjT5ohFRhiMcnhEys4zw4LhObQnNRRD2b+PFa5z3v7iHRpVWpPZ4NWsg/
         L+0jK3ekCde7tlEMZbjdPYldx+4wbo+fuG1Lc=
MIME-Version: 1.0
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
Date: Sun, 30 Jan 2011 22:17:06 -0800
X-Google-Sender-Auth: wTdbrug_jRgq9vWiU9ZtKCqXiUI
Message-ID: <AANLkTikQye0k2kE7WjMjPkxuL+1C0YZZFdas1Ttf_jGn@mail.gmail.com>
Subject: Re: DMA40 improvements
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 2:18 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> Hi Dan,
>
> Here is a number of DMA40 hardening patches, and at last a
> cyclic DMA implementation.
>

Hi Linus when sending large sets of patches please include a few more
sentences of summary, a shortlog, and a diffstat  (similar to the info
git request-pull produces).  The former gives me a better idea of what
I am looking at, the latter two help me confirm that I applied what
you expected in the right order.

Thanks,
Dan

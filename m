Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0G0ORE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 10:17:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58366 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0G0ORB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 10:17:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eMezKb8XRZ/rOC+BkofUCTPjOl5A1h+NbL3Jikylb7M1A57GQ2c3c0tBhVfF0HkcGu
         3sWguhCzTpVlA6JjQ00bjTQrc8iex82/8v5YPqN5Fm2TiMOiSoP2gAgUJcK+A8WLPaMK
         g3gdJK2DjnfL4GWp/xgWZfYRDZHS1RyZwoxNQ=
MIME-Version: 1.0
In-Reply-To: <1276767215-4217-1-git-send-email-andy.shevchenko@gmail.com>
References: <1276767215-4217-1-git-send-email-andy.shevchenko@gmail.com>
Date: Tue, 27 Jul 2010 17:16:56 +0300
Message-ID: <AANLkTikeFP-BTsf_MJ79VyTzBshqQxdtu+GnnfcrcJJc@mail.gmail.com>
Subject: Re: [PATCH] kgdb: remove custom hex_to_bin() implementation
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Jason Wessel <jason.wessel@windriver.com>, Martin Hicks <mort@sgi.com>,
        kgdb-bugreport@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 12:33 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> Cc: Jason Wessel <jason.wessel@windriver.com>
> Cc: Martin Hicks <mort@sgi.com>
> Cc: kgdb-bugreport@lists.sourceforge.net

Any comments?
The patch still valid for linux-next tree (I did cherry-pick today).

-- 
With Best Regards,
Andy Shevchenko

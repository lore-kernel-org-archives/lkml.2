Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab0LJXQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 18:16:30 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:36365 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0LJXQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 18:16:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=WcpxkEjVwYhNbnQuCSse0oNTnbYdvmuUC6QKH8CtNmwGsPh/2Jr8rJv/eAjZyyXZpE
         RHXNosbE2eqgDUz9At8rEd1WoGAnvZvRaJ+bblK2i5y0tqMj2/ckLM8LnaDiOesbYlfA
         llUyMhKhRwert2+hSebBL5I6b35EaJkdLcMV0=
MIME-Version: 1.0
In-Reply-To: <AANLkTikNgTObTt7nfxymn+3_B1+xDOB9X1wE2bgJRnA9@mail.gmail.com>
References: <AANLkTikNgTObTt7nfxymn+3_B1+xDOB9X1wE2bgJRnA9@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 10 Dec 2010 15:16:06 -0800
Message-ID: <AANLkTik57cKhUq6hW2akn9CPBh8=dYm1okBL4M8rfZEN@mail.gmail.com>
Subject: Re: compat-wireless-2.6.37-rc5-3-sn.tar.bz2 release
To: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 2:43 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> 02-ath9k-no-aggr-VO.patch
> 03-mac80211-no-aggr-VO.patch

I had to remove these to to compile on 2.6.31.

> The juicy link:
>
> http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-rc5-3-sn.tar.bz2

A new release which fixes a compile issue on 2.6.31:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-rc5-4-sn.tar.bz2

  Luis

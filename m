Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab0IYCwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 22:52:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49189 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab0IYCwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 22:52:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AK1D1ia28hHt+MON31DuP1DebMsnpEigybEn6/tywnvNGEGT4KtYN2j3HC+IQc+KW8
         sIyxaGm3CKMzAmFanRASIWKFY7WsmOb4TIHYgMCL6mtzC/H6TXl8wezV7WwzjSbXdykw
         aCq6uyH2NEoL+0JBDKh1dBn0H6FpE1GmsshL4=
MIME-Version: 1.0
In-Reply-To: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
Date: Sat, 25 Sep 2010 10:52:20 +0800
Message-ID: <AANLkTinDVs46mn1apGUy2ALauzO+f5sOhKhWr8MGk8=n@mail.gmail.com>
Subject: Re: [PATCH 01/24] base: change to new flag variable
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: matt mooney <mfm@muteddisk.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 3:17 AM, matt mooney <mfm@muteddisk.com> wrote:
> Replace EXTRA_CFLAGS with ccflags-y.
>
> Signed-off-by: matt mooney <mfm@muteddisk.com>

Nice work, matt!

The whole patch set looks good for me:

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Just please do remember to Cc linux-kbuild and Michal next time.

Thanks!

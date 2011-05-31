Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab1EaJHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:07:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49684 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758457Ab1EaJHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:07:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BofnOJX2fcXF8Y09WJCHlqKL/OtZ1CXIcK1ENLQuIel1kwoWtAGj+btlI0pDVkL1Fw
         gc2BcyDOjssQ8M2s+Ea5tpDatX1zK+Cvu67Az8Ue5IveN9uAabmUS0zWh2mfIKJ+duvp
         tjoGNeq14Byt/nGMIhrRKJ7yrcbqGxYemHyDQ=
MIME-Version: 1.0
In-Reply-To: <1306767052-15593-3-git-send-email-mmarek@suse.cz>
References: <1306767052-15593-1-git-send-email-mmarek@suse.cz>
	<1306767052-15593-3-git-send-email-mmarek@suse.cz>
Date: Tue, 31 May 2011 17:07:45 +0800
Message-ID: <BANLkTinB96saeLFZPG88Rtjq30gioj8hRw@mail.gmail.com>
Subject: Re: [PATCH 2/4] kbuild: Fix <linux/version.h> for X.Y versions
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 10:50 PM, Michal Marek <mmarek@suse.cz> wrote:
> expr treats all numbers as decimals, so prepending a zero is safe. Note
> that the KERNEL_VERSION() macro still takes three arguments, 3.0 has to be
> written as KERNEL_VERSION(3,0,0).
>
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

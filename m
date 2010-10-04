Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab0JDNAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 09:00:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38903 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab0JDNAl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 09:00:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wBny8IdG9ZBPdTC7fHA5Tz+2r3E8U/rG9f6AdtCSH5W5DzWoPB/hadobW4AHHmstzO
         /leJzYvS7RP3E9X/8MKOzWBdJRHJlIDkPQaf4t08UxOJJ2+XdK0jX/ZYAttSdW3ynnBs
         OLEuGx9rqnLpGv9kg8kBp/12IbazwEdTvjOQ0=
MIME-Version: 1.0
In-Reply-To: <20100924093206.GD5453@cr0.nay.redhat.com>
References: <AANLkTinwXj92VLVYqDhvUAusY_MdBQPAYnGBKVgfNLrO@mail.gmail.com>
	<20100924093206.GD5453@cr0.nay.redhat.com>
Date: Mon, 4 Oct 2010 14:00:40 +0100
Message-ID: <AANLkTi=ykH+gTujw+x1c107V6wXfZUT66uHBQ1o6NgK+@mail.gmail.com>
Subject: Re: [PATCH] kconfig: Use PATH_MAX instead of 128 for path buffer sizes.
From: Will Newton <will.newton@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 10:32 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Sep 22, 2010 at 03:59:13PM +0100, Will Newton wrote:
>>This prevents the buffers being overflowed when using a config
>>file with a long name. PATH_MAX is used elsewhere in the same
>>file, so use it here as well.
>>
>>Signed-off-by: Will Newton <will.newton@imgtec.com>
>
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>
> Thanks!

Ping!

Could someone take this please?

Thanks,

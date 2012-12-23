Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab2LWOZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 09:25:55 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:39523 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2LWOZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 09:25:53 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUV4WEu6xp=-TyHH2z4Zcz8g0iHY2ZVk-jBJNt1azcXa2A@mail.gmail.com>
References: <CA+icZUXJeWNceo_y-TSUVzXmjbrauWmCdkgW3EJtr_vpbcrk-A@mail.gmail.com>
	<20121223114213.GB8386@liondog.tnic>
	<CA+icZUXeddp5UZ10ZWTsWLnmegHGJ+VHnr4=oAm34hXgHD2FDg@mail.gmail.com>
	<CA+icZUU2OdNq5WKd7abNNe2eevxZBbMRS0eBGyU_rzjVBAgcOg@mail.gmail.com>
	<CA+icZUVxdp-Lcf4FLfY-80qvVsTQn-ajfh8vn2T=FC6-QbLv7w@mail.gmail.com>
	<CAM_iQpVdqYceHejqyQOn5wqj-xQFjn6E4u5ws4MuoOd=SiVtww@mail.gmail.com>
	<CA+icZUV4WEu6xp=-TyHH2z4Zcz8g0iHY2ZVk-jBJNt1azcXa2A@mail.gmail.com>
Date: Sun, 23 Dec 2012 22:25:53 +0800
Message-ID: <CAM_iQpU5VLGOAcZ=RfF8VqpRNTy7rueVpm=+U0Zy5SoAYk4THw@mail.gmail.com>
Subject: Re: [3.8-rc1] Networking problems after pulling-in net.git#master
From: Cong Wang <xiyou.wangcong@gmail.com>
To: sedat.dilek@gmail.com
Cc: Borislav Petkov <bp@alien8.de>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 10:14 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> [ CCing Eric ]
>
> YES, thie fixes my problem.
> But your patch was somehow malformed, so I attached mine.
>

Thanks for testing!

I knew it as I replied in wed Gmail. :) I will send a normal patch
with your Reported-by and Tested-by.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1GRTAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:00:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51906 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab1GRTAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:00:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com>
References: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net>
	<CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com>
Date: Mon, 18 Jul 2011 15:00:07 -0400
Message-ID: <CACqU3MVc-e-CHZz8kWnEbqYOMPe867kFup2K+ycv8MQPy=7ByA@mail.gmail.com>
Subject: Re: [PATCH] Avoid Wunused-but-set warning
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, linux-kbuild@vger.kernel.org,
        Nir Tzachar <nir.tzachar@gmail.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 10, 2011 at 12:16 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Sun, Jul 10, 2011 at 12:24 AM, Raghavendra D Prabhu
> <rprabhu@wnohang.net> wrote:
>> Hi,
>>    I am seeing Wunused-but-set warning while make nconfig.  Looks like
>>    active_menu is not used. Removing it fixes the warning.
>>
>> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Michal, ping ?

 - Arnaud

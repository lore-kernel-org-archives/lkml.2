Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab1GJQYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 12:24:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61061 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab1GJQY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 12:24:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com>
References: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net>
	<CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com>
Date: Sun, 10 Jul 2011 12:24:28 -0400
Message-ID: <CACqU3MUgVTpc6kBvBiw7rtyn_JTA-JPrbnvai3Vnq+UWk-jSbQ@mail.gmail.com>
Subject: Re: [PATCH] Avoid Wunused-but-set warning
From: Arnaud Lacombe <lacombar@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, linux-kbuild@vger.kernel.org,
        Nir Tzachar <nir.tzachar@gmail.com>, linux-kernel@vger.kernel.org
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
Out of curiosity, what is your status to ACK such patch ? You are
neither nconf author (Nir Tzachar), nor kbuild/kconfig maintainer
(Michal Marek), neither have you made any change in scripts/kconfig,
and finally your are not in the MAINTAINERS file (may have had to do
with some fancy tree-wide permission on trivial patch).

Thanks,
 - Arnaud

> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

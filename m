Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1GJQtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 12:49:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38761 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab1GJQto convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 12:49:44 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MUgVTpc6kBvBiw7rtyn_JTA-JPrbnvai3Vnq+UWk-jSbQ@mail.gmail.com>
References: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net>
	<CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com>
	<CACqU3MUgVTpc6kBvBiw7rtyn_JTA-JPrbnvai3Vnq+UWk-jSbQ@mail.gmail.com>
Date: Mon, 11 Jul 2011 00:49:43 +0800
Message-ID: <CAM_iQpWW8cdme-X-hjtpTZ96pdKG4KaYab_n9QxzHLPiet7iOw@mail.gmail.com>
Subject: Re: [PATCH] Avoid Wunused-but-set warning
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, linux-kbuild@vger.kernel.org,
        Nir Tzachar <nir.tzachar@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 12:24 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Sun, Jul 10, 2011 at 12:16 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Sun, Jul 10, 2011 at 12:24 AM, Raghavendra D Prabhu
>> <rprabhu@wnohang.net> wrote:
>>> Hi,
>>>    I am seeing Wunused-but-set warning while make nconfig.  Looks like
>>>    active_menu is not used. Removing it fixes the warning.
>>>
>>> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>>
>> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>>
> Out of curiosity, what is your status to ACK such patch ? You are
> neither nconf author (Nir Tzachar), nor kbuild/kconfig maintainer
> (Michal Marek), neither have you made any change in scripts/kconfig,
> and finally your are not in the MAINTAINERS file (may have had to do
> with some fancy tree-wide permission on trivial patch).

I believe I worked on either Linux kernel or kbuild longer than you. :)

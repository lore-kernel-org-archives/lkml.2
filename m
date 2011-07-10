Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1GJQ2L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 12:28:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33629 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab1GJQ2H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 12:28:07 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MUgVTpc6kBvBiw7rtyn_JTA-JPrbnvai3Vnq+UWk-jSbQ@mail.gmail.com>
References: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net>
	<CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com>
	<CACqU3MUgVTpc6kBvBiw7rtyn_JTA-JPrbnvai3Vnq+UWk-jSbQ@mail.gmail.com>
Date: Sun, 10 Jul 2011 19:28:06 +0300
X-Google-Sender-Auth: iVlYlMcqOAwN2JM4bp9FHjXYKIo
Message-ID: <CAOJsxLF+4VOXJwRJL7npMngDTGztXk739_GcMLxsMzmsVcDCVw@mail.gmail.com>
Subject: Re: [PATCH] Avoid Wunused-but-set warning
From: Pekka Enberg <penberg@kernel.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 7:24 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
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
> Out of curiosity, what is your status to ACK such patch ?

What kind of status do you need to ACK such a simple patch?

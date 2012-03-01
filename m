Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab2CAWBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 17:01:44 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39100 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab2CAWBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 17:01:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of luiz.dentz@gmail.com designates 10.236.184.8 as permitted sender) smtp.mail=luiz.dentz@gmail.com; dkim=pass header.i=luiz.dentz@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120301.154415.1692328508436381200.davem@davemloft.net>
References: <20120228.140558.1132853996225815681.davem@davemloft.net>
	<4F4F641E.7000501@collabora.co.uk>
	<1330604802.2465.43.camel@edumazet-laptop>
	<20120301.154415.1692328508436381200.davem@davemloft.net>
Date: Fri, 2 Mar 2012 00:01:40 +0200
Message-ID: <CABBYNZJ-xxQXAx+ecrkVLqmWFaUVqLcQLj0Jxa3McSLnkLJSJw@mail.gmail.com>
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to AF_UNIX
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, javier.martinez@collabora.co.uk,
        rodrigo.moya@collabora.co.uk, javier@collabora.co.uk,
        lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, Mar 1, 2012 at 10:44 PM, David Miller <davem@davemloft.net> wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Thu, 01 Mar 2012 04:26:42 -0800
>
>> Why adding an obscure set of IPC mechanism in network tree, and not
>> using (maybe extending) traditional IPC (Messages queues, semaphores,
>> Shared memory, pipes, futexes, ...).
>
> I actually don't understand why there is so much resistence to using a
> real bonafide on-the-wire protocol, and that way if you ever wanted to
> connect dbus instances on multiple machines or log dbus transactions
> remotely for debugging, you could just do it.

I don't think you understood the problem, we want something that scale
for less powerful devices, why do you think Android have all the
trouble to create binder?

Besides what is really the point in having AF_UNIX if you can't use
for what it is for?

"The  AF_UNIX (also known as AF_LOCAL) socket family is used to
communicate between processes on the same machine efficiently."

-- 
Luiz Augusto von Dentz

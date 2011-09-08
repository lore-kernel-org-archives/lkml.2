Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab1IHMa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:30:27 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:51430 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932400Ab1IHMaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:30:25 -0400
Message-ID: <4E68B561.4090106@profihost.ag>
Date: Thu, 08 Sep 2011 14:30:25 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: system freezing with 3.0.4
References: <4E68B484.4090204@profihost.ag>
In-Reply-To: <4E68B484.4090204@profihost.ag>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me - i'm not on list. Sorry that i forgot to mention this.

Am 08.09.2011 14:26, schrieb Stefan Priebe - Profihost AG:
> Hi list,
>
> we've updated some systems from 2.6.32 to 3.0.4 (renamed to 2.6.40.4 for
> comp. reasons) kernel. Since then we're expecting freezes every now and
> then. All in memory apps are still working but nothing which reads or
> writes from or to disk (it seems to me like that).
>
> If you're already conncted via ssh and running top suddenly idle is
> 99-100% and loads goes up to 500.
>
> Luckily i was able to trigger a sysrq on one machine fast enough:
> echo t >/proc/sysrq-trigger
>
> sysrq output is attached
>
> I hope somebody can help.
>
> Stefan

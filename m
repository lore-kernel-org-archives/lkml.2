Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453Ab0JZS0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:26:49 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:52908 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab0JZS0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:26:47 -0400
X-Auth-Info: JVM2waBNBciUhc0ZSr4flONLfQU5sX1MlAW8bZZ4Aac=
Message-ID: <4CC71DA4.3020600@grandegger.com>
Date: Tue, 26 Oct 2010 20:27:48 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: tomoya-linux@dsn.okisemi.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, morinaga526@dsn.okisemi.com,
        masa-korg@dsn.okisemi.com, margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build
 warnings
References: <4CC61B1B.3090602@dsn.okisemi.com>	<20101026.105206.15244527.davem@davemloft.net> <20101026.105545.200376685.davem@davemloft.net>
In-Reply-To: <20101026.105545.200376685.davem@davemloft.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 10/26/2010 07:55 PM, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Tue, 26 Oct 2010 10:52:06 -0700 (PDT)
> 
>> It doesn't in net-next-2.6 and that is what you should be generating
>                 ^^^^^^^^^^^^
>> patches against.
> 
> I mean net-2.6 of course.

Oh, this patch has various other issues, as Marc and I have already
pointed out, which should be fixed before the driver hits the user.
Unfortunately, the CC to netdev of our reviews got lost somehow, sorry
for the inconvenience, but the original author should have received it.
Tomoya, could you (or somebody else) please also fix the remaining
issues quickly?

Thanks,

Wolfgang.

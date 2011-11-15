Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab1KOWfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:35:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44581 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484Ab1KOWf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:35:29 -0500
MIME-Version: 1.0
In-Reply-To: <20111115142130.796d52c3@s6510.linuxnetplumber.net>
References: <cover.1321384662.git.david.decotigny@google.com>
 <005cae310e19433c9f68c178805f16c774e8dedd.1321384662.git.david.decotigny@google.com>
 <20111115142130.796d52c3@s6510.linuxnetplumber.net>
From: David Decotigny <david.decotigny@google.com>
Date: Tue, 15 Nov 2011 14:35:08 -0800
Message-ID: <CAG88wWa4Un2iwcFthxxVmeguPpQciovRd4+QqF_L=pxQ1f3vdw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 6/8] forcedeth: account for dropped RX frames
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 15, 2011 at 2:21 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> There is already an rx_dropped statistic in netdevice structure,
> why do you need your own in ethtool?

Sorry, I think my commit message was (once again) inaccurate. This
commit doesn't really "add" the stat, instead it adds code to update
the standard stats (struct rtnl_link_stats64).

Regards,

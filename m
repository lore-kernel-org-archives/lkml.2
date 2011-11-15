Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab1KOWVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:21:41 -0500
Received: from mail.vyatta.com ([76.74.103.46]:54507 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab1KOWVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:21:33 -0500
Date: Tue, 15 Nov 2011 14:21:30 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Decotigny <david.decotigny@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>
Subject: Re: [PATCH net-next v4 6/8] forcedeth: account for dropped RX
 frames
Message-ID: <20111115142130.796d52c3@s6510.linuxnetplumber.net>
In-Reply-To: <005cae310e19433c9f68c178805f16c774e8dedd.1321384662.git.david.decotigny@google.com>
References: <cover.1321384662.git.david.decotigny@google.com>
	<005cae310e19433c9f68c178805f16c774e8dedd.1321384662.git.david.decotigny@google.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Nov 2011 11:25:39 -0800
David Decotigny <david.decotigny@google.com> wrote:

> This adds the stats counter for dropped RX frames.
> 

There is already an rx_dropped statistic in netdevice structure,
why do you need your own in ethtool?



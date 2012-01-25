Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab2AYHL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 02:11:28 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32876 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2AYHL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 02:11:27 -0500
MIME-Version: 1.0
In-Reply-To: <20120124.230203.1478271172075708903.davem@davemloft.net>
References: <20120123.134352.1621146585245670953.davem@davemloft.net>
 <CAGsizzJnQ6b6eSC0ZnAtFguU7_xDfWFPSY6L4DWXc24F+Ts2XQ@mail.gmail.com>
 <CAOzFzEjE7b-Y+_vOWeBKbHDkURRcYXomSTcwB91vKHVWQxBVsg@mail.gmail.com> <20120124.230203.1478271172075708903.davem@davemloft.net>
From: Jesse Gross <jesse@nicira.com>
Date: Tue, 24 Jan 2012 23:11:06 -0800
Message-ID: <CAEP_g=9H9dV9=qtFPh4YeTNQ-t+UZGw-YqZ6hFWVNXjFy+GCZg@mail.gmail.com>
Subject: Re: [patch v4, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
To: David Miller <davem@davemloft.net>
Cc: joseph.glanville@orionvm.com.au, steweg@ynet.sk, eric.dumazet@gmail.com,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 8:02 PM, David Miller <davem@davemloft.net> wrote:
> From: Joseph Glanville <joseph.glanville@orionvm.com.au>
> Date: Wed, 25 Jan 2012 14:48:37 +1100
>
>> The reason why this patch is useful is that it stands to be the only
>> true mulitpoint L2 VPN with a kernel space forwarding plane.
>
> So what you're telling me is that I added this huge openvswitch
> thing essentially for nothing?

I think it's actually the opposite - Open vSwitch can be used to
implement this type of thing as well as for many other use cases.  On
the other hand, even when implementing a multipoint L2 solution it can
be useful to have additional levels of control but you can't do that
with this patch because it essentially statically glues together
tunneling and bridging.

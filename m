Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab1AKQJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:09:25 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48622 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab1AKQJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:09:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QiQDW7XIFaFctaYnW+u/LGfCPIWSYW3v4iBMidYT4+CCZ01Mkc2MCf6YPizViNYuCr
         p+8xhAz/IioaK3ZsnfcQ2pMBzBWhtgZmhDmdtZ1Q2ocVn9AEKQ3L8ySdaqiaQuAlxfc5
         w0n+DX8WwlnOaWaXvh1yrnENVaLowPxFeCxNk=
Date: Wed, 12 Jan 2011 00:09:18 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steve French <sfrench@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: 2.6.37-git5 - Lots of undefined symbols (ewma_init,
 dev_getbyhwaddr_rcu, sysctl_max_syn_backlog, sysctl_ip_default_ttl,
 d_set_d_op, mntput_long, input_mt_init_slots, etc.)
Message-ID: <20110111160918.GG17312@hack>
References: <AANLkTi==VazfSaRYt4q2ehtzebCnYTJkfgt1Jtggn5kf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi==VazfSaRYt4q2ehtzebCnYTJkfgt1Jtggn5kf@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 11:00:19AM -0500, Miles Lane wrote:
>ERROR: "ewma_init" [net/mac80211/mac80211.ko] undefined!
>ERROR: "ewma_add" [net/mac80211/mac80211.ko] undefined!
>ERROR: "dev_getbyhwaddr_rcu" [net/llc/llc2.ko] undefined!
>ERROR: "sysctl_max_syn_backlog" [net/ipv6/ipv6.ko] undefined!
>ERROR: "rtnl_af_unregister" [net/ipv6/ipv6.ko] undefined!
>ERROR: "rtnl_af_register" [net/ipv6/ipv6.ko] undefined!
>ERROR: "__rtnl_af_unregister" [net/ipv6/ipv6.ko] undefined!
>ERROR: "tcp_v4_tw_get_peer" [net/ipv6/ipv6.ko] undefined!
>ERROR: "inet_getpeer" [net/ipv6/ipv6.ko] undefined!
>ERROR: "inet_putpeer" [net/ipv6/ipv6.ko] undefined!
>ERROR: "tcp_v4_get_peer" [net/ipv6/ipv6.ko] undefined!
>ERROR: "sysctl_ip_default_ttl" [net/ipv4/xfrm4_mode_tunnel.ko] undefined!
>ERROR: "sysctl_ip_default_ttl" [net/ipv4/netfilter/ipt_REJECT.ko] undefined!
>ERROR: "d_set_d_op" [fs/isofs/isofs.ko] undefined!
>ERROR: "d_set_d_op" [fs/hfsplus/hfsplus.ko] undefined!
>ERROR: "d_set_d_op" [fs/hfs/hfs.ko] undefined!
>ERROR: "d_set_d_op" [fs/fat/vfat.ko] undefined!
>ERROR: "d_set_d_op" [fs/fat/msdos.ko] undefined!
>ERROR: "d_set_d_op" [fs/fat/fat.ko] undefined!
>ERROR: "d_set_d_op" [fs/cifs/cifs.ko] undefined!
>ERROR: "d_drop" [fs/cifs/cifs.ko] undefined!
>ERROR: "d_set_d_op" [fs/autofs4/autofs4.ko] undefined!
>ERROR: "rename_lock" [fs/autofs4/autofs4.ko] undefined!
>ERROR: "__d_drop" [fs/autofs4/autofs4.ko] undefined!
>ERROR: "mntput_long" [drivers/mtd/mtdchar.ko] undefined!
>ERROR: "input_mt_init_slots" [drivers/input/mouse/psmouse.ko] undefined!
>ERROR: "input_mt_report_slot_state" [drivers/input/mouse/psmouse.ko] undefined!
>make[2]: *** [__modpost] Error 1
>

Try to rebuild the kernel from a clean directory.

-- 
Live like a child, think like the god.
 

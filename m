Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab0KWA2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 19:28:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:29771 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab0KWA2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 19:28:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,239,1288594800"; 
   d="scan'208";a="860363911"
Subject: Re: 2.6.37-rc2 after KVM shutdown - unregister_netdevice: waiting
 for vmtst01eth0 to become free. Usage count = 1
From: "Alex,Shi" <alex.shi@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        davem@davemloft.net
Cc: "Chen, Tim C" <tim.c.chen@intel.com>, "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <AANLkTi=kx3uzrf29K7U8BFt2oTA_Dtw=4r2LdWPFUKv7@mail.gmail.com>
References: <20101116084148.GA3781@pcnci.linuxbox.cz>
	 <1289900812.5372.1.camel@edumazet-laptop>
	 <20101118062822.GB3781@pcnci.linuxbox.cz>
	 <1290071813.2781.1.camel@edumazet-laptop>
	 <AANLkTi=kx3uzrf29K7U8BFt2oTA_Dtw=4r2LdWPFUKv7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 08:27:08 +0800
Message-ID: <1290472028.16282.71.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Seems the problem fixing is still out of 37-rc3 kernel. It block our
network performance testing. I am glad to see the fixing patch in
upstream. 


> 
> On Thu, Nov 18, 2010 at 5:16 PM, Eric Dumazet <eric.dumazet@gmail.com>
> wrote:
>         Le jeudi 18 novembre 2010 à 07:28 +0100, Nikola Ciprich a
>         écrit :
>         > > Yep, this is a known problem, thanks !
>         > >
>         > > fix is there :
>         > >
>         > > http://patchwork.ozlabs.org/patch/71354/
>         > Thanks Eric, this indeed fixes the problem..
>         > I noticed the fix didn't make it to 2.6.37-rc2-git3 though,
>         > maybe it just got omited?
>         > anyways, thanks for help!
>         > n.
>         
>         
>         Its in David Miller net-2.6 tree (all pending network patches
>         for
>         current linux-2.6 version), so it'll be included next time
>         David push
>         its tree to Linus, dont worry ;)
>         
>         

> 



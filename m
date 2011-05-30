Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1E3CBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 22:01:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59582 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab1E3CBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 22:01:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DHqFKcRqAcTLXajf1YEHny/unAL12IenPByMsr5oafVgGTZtNc7k/YNpuFXLJfHhDy
         uDueWoTQh5KphVNrDaQfWIc/KKSO8Bvr+2PindDO+QHQ3xDLtCTu+XskVgKJuInJLIRA
         H/MoefZEEzp4iv2ET9uMJpbVCwv7/hmkgxaFI=
Subject: Re: linux-next: build warning in Linus' tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Patrick McHardy <kaber@trash.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
In-Reply-To: <20110530114333.6aa13281.sfr@canb.auug.org.au>
References: <20110530114333.6aa13281.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 04:01:03 +0200
Message-ID: <1306720863.30021.25.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 30 mai 2011 à 11:43 +1000, Stephen Rothwell a écrit :
> Hi all,
> 
> In Linus' tree, today's linux-next build (powerpc ppc64_defconfig)
> produced this warning:
> 
> net/ipv4/netfilter/nf_nat_standalone.c: In function 'nf_nat_fn':
> net/ipv4/netfilter/nf_nat_standalone.c:119:2: warning: case value '4' not in enumerated type 'enum ip_conntrack_info'
> net/ipv4/netfilter/ipt_CLUSTERIP.c: In function 'clusterip_tg':
> net/ipv4/netfilter/ipt_CLUSTERIP.c:324:3: warning: case value '4' not in enumerated type 'enum ip_conntrack_info'
> 
> I am now using gcc v4.5.2.

I sent a patch for this some days ago, not sure what happened to it.

David Acked it, but Patrick is a bit busy these days.

http://www.spinics.net/lists/netdev/msg164837.html

Thanks



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab1EQK1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 06:27:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46331 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1EQK1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 06:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ne/7uwVWWAYdewvDeuuWkeOCN46yBw8yT8pI85odThxzOuiYj4gYmXia6dr08wvXsb
         anRt1UKGiDliBr5BuOUAhnQcnaDExGjSgvIuKLf/fkBHH5/ayEoTXKrxAT5pdOUSe8hr
         x93ICZr2LqHoWMZ3tJ6huSFYlyr93MyxxTH+8=
Subject: Re: [PATCH] net: ping: fix build failure
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: David Miller <davem@davemloft.net>, randy.dunlap@oracle.com,
        sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110517101656.GA28685@albatros>
References: <20110516151019.be338f1c.sfr@canb.auug.org.au>
	 <20110516123534.5d3a51b9.randy.dunlap@oracle.com>
	 <20110516.153844.1072050131335197211.davem@davemloft.net>
	 <20110517101656.GA28685@albatros>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 12:27:04 +0200
Message-ID: <1305628024.2850.51.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 mai 2011 à 14:16 +0400, Vasiliy Kulikov a écrit :
> On Mon, May 16, 2011 at 15:38 -0400, David Miller wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > Date: Mon, 16 May 2011 12:35:34 -0700
> > 
> > > On Mon, 16 May 2011 15:10:19 +1000 Stephen Rothwell wrote:
> > > when CONFIG_PROC_SYSCTL is not enabled:
> > > 
> > > ping.c:(.text+0x52af3): undefined reference to `inet_get_ping_group_range_net'
> > 
> > Vasiliy, please fix this.
> 
> I wonder whether there is any way to test such unusual configurations?
> Only randconfig or are there any (partly-)automated tools for it?
> 
> 
> [PATCH] net: ping: fix build failure
> 
> If CONFIG_PROC_SYSCTL=n the building process fails:
> 
>     ping.c:(.text+0x52af3): undefined reference to `inet_get_ping_group_range_net'
> 
> Moved inet_get_ping_group_range_net() to ping.c.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



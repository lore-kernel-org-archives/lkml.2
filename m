Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0IQFef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 01:34:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab0IQFec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 01:34:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pw5RHNAx/Nukd249ZvXFF1G8eaFGvfR9pJGr3ChIvOkE8fHpd19PD0HN61KtLzv0VX
         rR/z/+tgGFhoC1BGHLL7xA9ln2WwCadBgiaSM74tcLPWyeyWvrWzN8bVm5fu6DM0bLFW
         Dzpwnk+3v8sHhTOcVJyGGuWvDK7+sBTtQkoGY=
Subject: Re: linux-next: build failure after merge of the rcu tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, paulmck@linux.vnet.ibm.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20100916.213939.24608537.davem@davemloft.net>
References: <20100917124238.aa0596cb.sfr@canb.auug.org.au>
	 <20100916.213939.24608537.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 07:34:26 +0200
Message-ID: <1284701666.4784.36.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 16 septembre 2010 à 21:39 -0700, David Miller a écrit :
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 17 Sep 2010 12:42:38 +1000
> 
> > Subject: [PATCH] net: include inetdevice.h for rcu_dereference_raw api change
> > 
> > rcu_dereference_raw() now needs to know the type of its argument.
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> I've tossed this into net-next-2.6, thanks!

Thanks guys




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab1FVFHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 01:07:00 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62864 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab1FVFG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 01:06:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:message-id
         :mime-version;
        b=S4gC2ZdLXydDLfydDk66I/vmHcSbDvow1M6P92rS4aZ1TxlJzGHm+Z4L2ZzwBavav0
         PUdZc43JF0buPw4DGG6bzEz11lqXStsb1frauyzra2h9zYubOekfDN/EzMZMf80FnMD/
         OkVrbQNrHLoWxFW8YWjf1qNyS5K/yg34qsc38=
Subject: Re: [PATCH 2/2] mtd: onenand/samsung.c: fix build error
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Brian Norris <computersforpeace@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Date: Wed, 22 Jun 2011 08:07:41 +0300
In-Reply-To: <BANLkTi=MiT1PrcJMdAfegTg74BQYNHC2fw@mail.gmail.com>
References: <1308298176.13535.1.camel@phoenix>
	 <1308298294.13535.3.camel@phoenix>
	 <BANLkTi=MiT1PrcJMdAfegTg74BQYNHC2fw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1308719266.18119.31.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-17 at 10:10 -0700, Brian Norris wrote:
> Hi,
> 
> On Fri, Jun 17, 2011 at 1:11 AM, Axel Lin <axel.lin@gmail.com> wrote:
> > -       err = mtd_device_parse_register(&info->mtd, NULL, 0,
> > +       err = mtd_device_parse_register(onenand->mtd, NULL, 0,
> >                        pdata ? pdata->parts : NULL,
> >                        pdata ? pdata->nr_parts : 0);

Yeah, just did this, thanks.

-- 
Best Regards,
Artem Bityutskiy


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab1EJMgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:36:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59948 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab1EJMgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=hJVafdouADklsUey1CB8JrXlckC0FzzPRWmXA4I43MB52Z6bZ+1MijDp68Pl77HhrG
         gpf2gZ/5kcZbQsRcpdydckUmMX+it8uTOCAj3IoFms0ZtMzZ5YxZJiiJVNuxGPbDKtOd
         GSeaJZDSeQOI/NdOAr+oMsY3BSnqA7RhBTDlY=
Subject: Re: [PATCH] drivers:regulator:change debug statement be consistent
 with the style of the rest.
From: Wanlong Gao <wanlong.gao@gmail.com>
Reply-To: wanlong.gao@gmail.com
To: Jiri Kosina <jkosina@suse.cz>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk
In-Reply-To: <alpine.LNX.2.00.1105101011550.28291@pobox.suse.cz>
References: <1302968543-3150-1-git-send-email-wanlong.gao@gmail.com>
	 <20110416175440.GD25811@opensource.wolfsonmicro.com>
	 <4DAA3A25.30501@gmail.com>
	 <alpine.LNX.2.00.1105101011550.28291@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: Linux kernel
Date: Tue, 10 May 2011 20:36:35 +0800
Message-ID: <1305030995.3140.0.camel@Tux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2011-05-10二的 10:12 +0200，Jiri Kosina写道：
> On Sun, 17 Apr 2011, Wanlong Gao wrote:
> 
> > 
> > 
> > change the "mc13783_regulator_probe" string in the function
> > "mc13783_regulator_probe"
> > to "__func__" for the debug statement be consistent with the style of the rest
> > of
> > the file.
> > 
> > Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > 
> > ---
> >  drivers/regulator/mc13783-regulator.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/regulator/mc13783-regulator.c
> > b/drivers/regulator/mc13783-regulator.c
> > index 23249cb..b8a00c7 100644
> > --- a/drivers/regulator/mc13783-regulator.c
> > +++ b/drivers/regulator/mc13783-regulator.c
> > @@ -341,7 +341,7 @@ static int __devinit mc13783_regulator_probe(struct
> > platform_device *pdev)
> >         struct mc13783_regulator_init_data *init_data;
> >         int i, ret;
> > 
> > -       dev_dbg(&pdev->dev, "mc13783_regulator_probe id %d\n", pdev->id);
> > +       dev_dbg(&pdev->dev, "%s id %d\n", __func__, pdev->id);
> > 
> >         priv = kzalloc(sizeof(*priv) +
> >                         pdata->num_regulators * sizeof(priv->regulators[0]),
> 
> Applied.
> 
> BTW, your mailer is damaging the in-line patches. I have fixed this now, 
> but please fix that for your future submissions.
> 
> Thanks,
> 

Thanks, and I'll fix it next time.

Wanlong Gao


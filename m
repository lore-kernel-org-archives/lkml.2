Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab0C3PKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 11:10:10 -0400
Received: from web94916.mail.in2.yahoo.com ([203.104.17.196]:42163 "HELO
	web94916.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752051Ab0C3PKI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 11:10:08 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Mar 2010 11:10:07 EDT
Message-ID: <792863.15718.qm@web94916.mail.in2.yahoo.com>
X-YMail-OSG: WqGzP3EVM1kX.tm52Wqff3bL95Z4Nxsc_yL.zqzWSvqlsjt
 TAr2rvLz2CzKSpzRnVmOiqSRM2ovogAalAXas1Bi.7wcGNFO1KxyZdaWd6mk
 95HFjLVMwHtrUu0Rn6dtR6yXbMSp0gwjfQYPDsiEShBnkIXWEtL3P8DRHyk1
 Z_dfZOX7OGrea6yuUqWBh8RxQcHSlrtO1wD7MGnmvTnpoaYUthhPEqfp4IU3
 GZ_nggaOUea_a9N1IG3R.Fi2chnoqnbQ0ZegV7ruYfHKZgArGHvJJxJFMXZ3
 JnM0k8wFd1ChB5FHo1HLlQig-
X-RocketYMMF: pavan_savoy
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Tue, 30 Mar 2010 20:33:25 +0530 (IST)
From: Pavan Savoy <pavan_savoy@ti.com>
Reply-To: pavan_savoy@ti.com
Subject: Re: [PATCH] drivers:staging: sources for HCI LL PM protocol
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: marcel@holtmann.org, gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20100330122440.1e3d8bf1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Tue, 30/3/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Subject: Re: [PATCH] drivers:staging: sources for HCI LL PM protocol
> To: pavan_savoy@ti.com
> Cc: marcel@holtmann.org, gregkh@suse.de, linux-kernel@vger.kernel.org, pavan_savoy@yahoo.co.in
> Date: Tuesday, 30 March, 2010, 4:54 PM
> 
> > +static struct ll_struct_s *ll;
> 
> More magic globals. I think this more than anything else
> demonstrates why
> you need some kind of proper per device context passed
> around
> 

The ST KIM module, is a platform device, which I use to pass the GPIO data from the arch/XX/board-XXX.c files, so, suppose we do have 2 devices for a platform, then I would need 2 platform devices right ?

And there-by can I use that platform device context ?
However the problem really is,

Suppose a BT driver wants to do an st_register() and use ST as its transport, how can I then tie it to a device ?


> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


      Your Mail works best with the New Yahoo Optimized IE8. Get it NOW! http://downloads.yahoo.com/in/internetexplorer/

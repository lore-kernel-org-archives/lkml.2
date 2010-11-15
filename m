Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab0KORxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:53:45 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64945 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab0KORxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:53:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=CBistYsLCQIlqVoeOkIxh7jYasQDGDI5Y/gHg7QDlZvGG/WPS/n/0We0pyimZ7NS6S
         HeVwi/dX2w7UMrCZ6Q72MaW2J8p7QZ6y7do3l/9fgh8vuLBilPlVuu5BZR3TB+3ppiCq
         WM9XsbGGVUJXY5Fk5Rcl5+Ct9p+3F2heYk7Hk=
MIME-Version: 1.0
In-Reply-To: <20101115065919.GB14442@core.coreip.homeip.net>
References: <4CD8566D.1020202@vlnb.net> <20101109002829.GA22633@kroah.com>
 <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net>
 <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com> <20101115065919.GB14442@core.coreip.homeip.net>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 15 Nov 2010 18:53:20 +0100
X-Google-Sender-Auth: V9CPkqsF8yR_jaoJyfO_k0kw8dg
Message-ID: <AANLkTinSpmjL+eK+UHSViETJn8uqcSE63Zi8XUKnmfPi@mail.gmail.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <greg@kroah.com>, Vladislav Bolkhovitin <vst@vlnb.net>,
        Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>,
        James Smart <James.Smart@emulex.com>, Joe Eykholt <jeykholt@cisco.com>,
        Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>,
        Hannes Reinecke <hare@suse.de>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 7:59 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> [ ... ]
> This is quite unfortunate as I still have not seen the public comparison
> of the 2 implementations and the lists of benefits and shortfalls for
> both of them.

The reason why we are proposing SCST for upstream inclusion are:
- It has a large user base.
- The project is known for its high performance, low latency I/O and
excellent stability.
- A feature-wise overview can be found here:
http://scst.sourceforge.net/comparison.html.

Bart.

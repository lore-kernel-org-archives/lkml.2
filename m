Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab1KPCAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 21:00:48 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55031 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932895Ab1KPCAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 21:00:47 -0500
Message-ID: <1321408846.9189.5.camel@Joe-Laptop>
Subject: Re: [PATCH 3/4] mmc: Logging neatening
From: Joe Perches <joe@perches.com>
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Cliff Cai <cliff.cai@analog.com>, Nicolas Pitre <nico@fluxnic.net>,
        Chris Ball <cjb@laptop.org>, Sascha Sommer <saschasommer@freenet.de>,
        Alex Dubov <oakad@yahoo.com>, Bruce Chang <brucechang@via.com.tw>,
        Harald Welte <HaraldWelte@viatech.com>,
        Tony Olech <tony.olech@elandigitalsystems.com>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org
Date: Tue, 15 Nov 2011 18:00:46 -0800
In-Reply-To: <CAKYAXd8fki1HfFRuRyi4_HNLK6aiFM5NAbyKApgbGaaR=VOTEg@mail.gmail.com>
References: <cover.1321398814.git.joe@perches.com>
	 <d2c1a76fea1844ae7ac3e7e17183fb39df19178e.1321398814.git.joe@perches.com>
	 <CAKYAXd8_mDF68PnEnpuZZQ+O8-QmrfRpP4jv+SpHDx1juTxFGQ@mail.gmail.com>
	 <1321408236.9189.3.camel@Joe-Laptop>
	 <CAKYAXd8fki1HfFRuRyi4_HNLK6aiFM5NAbyKApgbGaaR=VOTEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 10:55 +0900, NamJae Jeon wrote:
> 2011/11/16 Joe Perches <joe@perches.com>:
> > On Wed, 2011-11-16 at 10:48 +0900, NamJae Jeon wrote:
> >
> > [123K of untrimmed reply]
> >
> > If you wrote something, I didn't find it.
> >
> 
> > -       dev_info(&pdev->dev, "DW MMC controller at irq %d, "
> > -                "%d bit host data width, "
> > -                "%u deep fifo\n",
> > +       dev_info(&pdev->dev,
> > +       "DW MMC controller at irq %d, %d bit host data width, %u deep fifo\n",
> >                 irq, width, fifo_size);
> 
> I think that tab is needed this "DW MMC controller at irq ...." ?

Argument alignment isn't always the right thing.

Very long formats should not necessarily be aligned
at the open parenthesis.  It helps to determine
when the format string or the dmesg output line length
is too long.






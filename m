Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab2EVMzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:55:16 -0400
Received: from smtp0.epfl.ch ([128.178.224.219]:38696 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753052Ab2EVMzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:55:13 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2012 08:55:13 EDT
From: Philippe =?ISO-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
To: Fabio Estevam <festevam@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marc Reilly <marc@cpdesign.com.au>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Date: Tue, 22 May 2012 14:48:28 +0200
Message-ID: <2220592.xdm62UZBs9@laptop>
Organization: EPFL - STI - LSRO1
User-Agent: KMail/4.8.3 (Linux/3.3.5-2.fc16.x86_64; KDE/4.8.3; x86_64; ; )
In-Reply-To: <CAOMZO5DJUXna-zn98Zs0exin+THQhB3SG9To5N-QEEcDYrmXRA@mail.gmail.com>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com> <20120522092552.GB21999@opensource.wolfsonmicro.com> <CAOMZO5DJUXna-zn98Zs0exin+THQhB3SG9To5N-QEEcDYrmXRA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 22 mai 2012 08:40:30 Fabio Estevam a écrit :
> Hi Philippe,
> 
> On Tue, May 22, 2012 at 6:25 AM, Mark Brown
> 
> <broonie@opensource.wolfsonmicro.com> wrote:
> > It's only this chip that's doing so.  I'd suggest putting a scope on it
> > and having a look at the formatted data.
> 
> Does mx31-moboard allow you to put the scope on the SPI lines
> connected to the mc13783?

Yes, I have access to MISO/MOSI/CLK, but not CS on mx31moboard.
BTW, mx31-ads give access to the full SPI bus, but I never booted it.

I cannot debug this right now, but I should be able to do it on friday.

Regards,

Philippe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab2JDXSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 19:18:33 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34030 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab2JDXSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 19:18:32 -0400
Message-ID: <1349392709.5198.2.camel@trivette>
Subject: Re: [PATCH] gpio: add TS-5500 DIO headers support
From: Vivien Didelot <vivien.didelot@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Date: Thu, 04 Oct 2012 19:18:29 -0400
In-Reply-To: <1348673827.2566.17.camel@trivette>
References: <1348620130-25987-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <1348673827.2566.17.camel@trivette>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Grant, Linus, any feedback?

Thanks,
Vivien

On Wed, 2012-09-26 at 11:37 -0400, Vivien Didelot wrote:
> > +config GPIO_TS5500
> > +     tristate "TS-5500 DIO Headers"
> > +     depends on TS5500
> > +     help
> > +       This driver supports the 3 Digital I/O headers of the
> Technologic
> > +       Systems TS-5500 platform: DIO1, DIO2, and the LCD port which
> may be
> > +       used as a DIO header.
> 
> I moved the GPIO_TS5500 entry at the good place in the "Memory mapped
> GPIO drivers" section. But I'm still worried about select/depends on.
> I removed the TS5500 symbol dependency, which is not defined yet (will
> be done in the future board support patch). Does the following entry
> seem good?
> 
>     config GPIO_TS5500
>             tristate "TS-5500 DIO Headers support"
>             help
>               This driver supports the 3 Digital I/O headers of the
>               Technologic Systems TS-5500 platform: DIO1, DIO2, and
> the
>               LCD port which may be used as a DIO header.
> 
> Regards,
> Vivien 


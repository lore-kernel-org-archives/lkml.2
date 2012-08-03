Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2HCRIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:08:35 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:36346 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2HCRIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:08:34 -0400
Date: Fri, 3 Aug 2012 19:07:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Amaury =?UTF-8?B?RGVjcsOqbWU=?= <amaury.decreme@gmail.com>
Cc: ben-linux@fluff.org, w.sang@pengutronix.de, rob@landley.net,
        jeffrey.t.kirsher@intel.com, akpm@linux-foundation.org,
        davem@davemloft.net, gregkh@linuxfoundation.org, joe@perches.com,
        ralf@linux-mips.org, dirk.brandewie@gmail.com,
        jayachandranc@netlogicmicro.com, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] I2C: SIS964: Bus driver
Message-ID: <20120803190758.34e67b1e@endymion.delvare>
In-Reply-To: <CAPXEm73QX7haU5p7HU+=+qo5wnivt6j+WH5bQGZ0ZK0Ek2Cuyw@mail.gmail.com>
References: <1344008145-14579-1-git-send-email-amaury.decreme@gmail.com>
	<20120803180712.1e768042@endymion.delvare>
	<CAPXEm73QX7haU5p7HU+=+qo5wnivt6j+WH5bQGZ0ZK0Ek2Cuyw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2012 18:36:36 +0200, Amaury Decrême wrote:
> > What is the rationale for not adding support for the new chip to
> > i2c-sis630 then? That would probably be a lot easier to review.
> >
> 
> I was afraid that adding SIS964 support to i2c-sis630 would lead
> to confusion.

There's nothing confusing, drivers supporting several devices are
legion. If the devices are really almost compatible, reusing an
existing driver is the way to go.

> I can try to submit a patch for i2c-sis630. In this case, do you think
> we should keep the 630 name or change it to something else to
> avoid misunderstanding ?

Keep the name. It is very common to name drivers by the name of the
first supported device, and changing a driver name is always a source
of trouble.

-- 
Jean Delvare

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab1GGLW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:22:57 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:17170 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab1GGLW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:22:56 -0400
Date: Thu, 7 Jul 2011 13:22:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Fubo Chen <fubo.chen@gmail.com>
Cc: sdevrien@cisco.com, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, guenter.roeck@ericsson.com
Subject: Re: [PATCH v3] Add support for the Philips SA56004 temperature
 sensor.
Message-ID: <20110707132242.0aaff4ea@endymion.delvare>
In-Reply-To: <BANLkTi=gAqpDNBjCXzvNEhSuzm=3Mg9rVg@mail.gmail.com>
References: <1307356845-10095-1-git-send-email-sdevrien@cisco.com>
	<BANLkTi=gAqpDNBjCXzvNEhSuzm=3Mg9rVg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jun 2011 21:54:37 +0200, Fubo Chen wrote:
> On Mon, Jun 6, 2011 at 12:40 PM,  <sdevrien@cisco.com> wrote:
> > +       } else
> > +       if (man_id == 0xA1) { /*  NXP Semiconductor/Philips */
> 
> No kernel coder writes like this. Has this ever been run through checkpatch ?

Actually, I wrote that code, and I am a kernel coder. You may not like
it, but at the time it seemed the best way to keep the function
readable. This particular style allows for better placement of
comments, which are many in this function.

As long as checkpatch doesn't complain about it, I will not consider
changing it, and will reject any attempt to do so (simply by comparing
the readability before and after the patch and inevitably coming up to
the conclusion that the change isn't worth it.)

-- 
Jean Delvare

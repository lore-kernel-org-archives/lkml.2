Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab2C1Msk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:48:40 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:17282 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2C1Msj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:48:39 -0400
Date: Wed, 28 Mar 2012 14:48:24 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Aaron Sierra <asierra@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guenter Roeck <guenter@roeck-us.net>, Peter Tyser <ptyser@xes-inc.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] [3.4] MFD pull request
Message-ID: <20120328144824.176ddbb6@endymion.delvare>
In-Reply-To: <20120327105534.GC17616@sortiz-mobl>
References: <20120327105534.GC17616@sortiz-mobl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Tue, 27 Mar 2012 12:55:34 +0200, Samuel Ortiz wrote:
> Hi Linus,
> 
> This is the MFD pull request for Linux 3.4. This is what we have:
> 
> * 4 new drivers: Freescale i.MX on-chip Anatop, Ricoh's RC5T583 and TI's
> TPS65090 and TPS65217.
> 
> * New variants support (8420, 8520 ab9540), cleanups and bug fixes for the
> abx500 and db8500 ST-E chipsets.
> 
> * Some minor fixes and update for the wm8994 from Mark.
> 
> * The beginning of a long term TWL cleanup effort coming from the TI folks.
> 
> * Various fixes and cleanups for the s5m, TPS659xx, pm860x, and MAX8997
> drivers.

What happened to Aaron's Intel ICH mfd driver? It has been floating
around for quite some time and did receive a fair amount of review and
testing, I really expected it to make it into kernel 3.4.

Thanks,
-- 
Jean Delvare

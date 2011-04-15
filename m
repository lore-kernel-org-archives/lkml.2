Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab1DOJcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 05:32:09 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:26305 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab1DOJcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 05:32:06 -0400
Date: Fri, 15 Apr 2011 11:31:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Thomas Renninger <trenn@suse.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH v5] hwmon: Add driver for AMD family 15h processor power
  information
Message-ID: <20110415113152.1627c5f3@endymion.delvare>
In-Reply-To: <20110414192011.GB773@alberich.amd.com>
References: <20110404160733.GA11818@alberich.amd.com>
	<20110405144536.GA5054@alberich.amd.com>
	<20110406135424.GC2177@alberich.amd.com>
	<20110408135407.GA12014@alberich.amd.com>
	<20110414192011.GB773@alberich.amd.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 21:20:11 +0200, Andreas Herrmann wrote:
> From: Andreas Herrmann <andreas.herrmann3@amd.com>
> 
> This CPU family provides NB register values to gather following
> TDP information
> 
> * ProcessorPwrWatts: Specifies in Watts the maximum amount of power
>   the processor can support.
> * CurrPwrWatts: Specifies in Watts the current amount of power being
>   consumed by the processor.
> 
> This driver provides
> 
> * power1_crit (ProcessorPwrWatts)
> * power1_input (CurrPwrWatts)
> (...)

Applied, thanks.

-- 
Jean Delvare

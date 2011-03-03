Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab1CCH4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:56:46 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:9030 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab1CCH4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:56:45 -0500
Date: Thu, 3 Mar 2011 08:56:31 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Eibach, Dirk" <Eibach@gdsys.de>
Cc: "Wolfram Sang" <w.sang@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <guenter.roeck@ericsson.com>, <lm-sensors@lm-sensors.org>,
        <rdunlap@xenotime.net>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4] hwmon: Add support for Texas Instruments ADS1015
Message-ID: <20110303085631.53016c75@endymion.delvare>
In-Reply-To: <48D3D52125C49B43AE880038E2E5314BB5BE6B@SRV101.gdsys.de>
References: <20110302181651.GA24054@pengutronix.de>
	<48D3D52125C49B43AE880038E2E5314BB5BE6B@SRV101.gdsys.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011 08:49:13 +0100, Eibach, Dirk wrote:
>  
> 
> > Still, there is a new property defined which _always_ needs
> > 
> > a) CCing devicetree-discuss (get_maintainer helps here)
> > b) Documentation in Documentation/devicetree/bindings
> > 
> > because it needs to be a lot more stable than platform_data.
> 
> Jean, should I supply a v5 with Documentation or should I supply a
> separate patch?

Separate patch. I'm not even the one who will review and apply it.

> > (I already lost the original mail, so I sadly can't forward it)
> 
> I have forwarded it to devicetree-discuss.

This is where the review will happen, and where hopefully someone will
pick up the patch.

-- 
Jean Delvare

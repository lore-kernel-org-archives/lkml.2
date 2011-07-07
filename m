Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab1GGOuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:50:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63983 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab1GGOuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:50:44 -0400
Date: Thu, 7 Jul 2011 07:50:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Frederick van der Wyck <fvanderwyck@gmail.com>
Cc: mjg59@srcf.ucam.org, gregkh@suse.de, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Platform: Samsung Q10 backlight driver
Message-ID: <20110707145036.GK7658@core.coreip.homeip.net>
References: <20110704214357.GA17428@ntl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704214357.GA17428@ntl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederick,

On Mon, Jul 04, 2011 at 10:43:57PM +0100, Frederick van der Wyck wrote:
>  
> +config SAMSUNG_Q10
> +	tristate "Samsung Q10 Extras"
> +	select BACKLIGHT_CLASS_DEVICE

Since the driver will not function without full i8042 code being present
I think you should add 'depends on SERIO_I8042' even though it compiles
without it being enabled.

Thanks.

-- 
Dmitry

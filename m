Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab1DAPSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:18:01 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:51465 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753358Ab1DAPSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:18:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=FPV/KtuzfywevqvqHAnsyQ0VGxT020I+cDhmnHR1c1TMIr+uQo3nRBvP3RalEE3MqBl2fvnGh507defyb3nzKcIez3jEY8SFAJwtk5RejWMz8XrBDYT5G4t5p0asRxEG;
Date: Fri, 1 Apr 2011 08:17:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: support for Synopsys DesignWare APB GPIO
Message-Id: <20110401081758.2d06bab7.rdunlap@xenotime.net>
In-Reply-To: <1301665638-29841-1-git-send-email-jamie@jamieiles.com>
References: <1301665638-29841-1-git-send-email-jamie@jamieiles.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  1 Apr 2011 14:47:18 +0100 Jamie Iles wrote:

> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index d3b2953..135d996 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -131,6 +131,14 @@ config GPIO_VX855
>  	  additional drivers must be enabled in order to use the
>  	  functionality of the device.
>  
> +config GPIO_DW
> +	bool "Synopsys DesignWare APB GPIO controller"
> +	depends on GPIOLIB
> +	help
> +	  Say M here to build support for the Synopsys DesignWare APB
> +	  GPIO controller found in some ARM systems.  This GPIO controller
> +	  supports upto 4 ports of GPIO and GPIO interrupts on port A.

	           up to

> +
>  comment "I2C GPIO expanders:"
>  
>  config GPIO_MAX7300


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

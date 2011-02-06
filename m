Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1BFUX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:23:29 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59287 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1BFUX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:23:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=H1QPaGDYTCOiT1gIoeENC+OOdUdAwEy15do8TNH9pXSYwCgml4mdT8HP/X9gweDZOq
         FfJuY8tL4xFXj4l0vEFPE+SU3YikTKf0Z9NoO2+SNxemuvrXqT1/ovQWBNIqTmtO8JMO
         23APBQfuO5i4TWfqLfu31vEat6TBtOElEUFJA=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net,
        nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] spi: New driver for Altera SPI
References: <20110203173430.GC6180@angua.secretlab.ca>
	<1296914523-13740-1-git-send-email-thomas@wytron.com.tw>
Date: Sun, 06 Feb 2011 21:23:22 +0100
In-Reply-To: <1296914523-13740-1-git-send-email-thomas@wytron.com.tw> (Thomas
	Chou's message of "Sat, 5 Feb 2011 22:02:03 +0800")
Message-ID: <87aai8zzd1.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Thomas" == Thomas Chou <thomas@wytron.com.tw> writes:

Hi,

 Thomas> +++ b/drivers/spi/Kconfig
 Thomas> @@ -53,6 +53,13 @@ if SPI_MASTER
 
 Thomas>  comment "SPI Master Controller Drivers"
 
 Thomas> +config SPI_ALTERA
 Thomas> +	tristate "Altera SPI Controller"
 Thomas> +	default n

'n' is the default anyway, so no need for this line.

-- 
Bye, Peter Korsgaard

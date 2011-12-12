Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1LLOmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:42:54 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:32859 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752693Ab1LLOmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:42:49 -0500
Message-ID: <4EE612E3.1010801@evidence.eu.com>
Date: Mon, 12 Dec 2011 15:42:43 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH RESEND 0/8] serial: 8250: support hw-based RS485 direction
 control
References: <1323450440-414-1-git-send-email-w.sang@pengutronix.de>
In-Reply-To: <1323450440-414-1-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/12/2011 18:07, Wolfram Sang ha scritto:
> Some 8250-variants control the direction pin for RS485 in hardware. Linux has
> RS485 support these days, so update the 8250-driver to adhere to that.
>
> Code is based on 3.2-rc4, tested on a OMAP-based custom board with a 16V2750.
> A git tree can be found here:
>
> 	git://git.pengutronix.de/git/wsa/linux-2.6.git 8250_rs485
>
> There is no code change since the initial post of this series. I updated some
> of the patch descriptions, though. A kind-of-ack from Claudio can be found here
> [1]. Please consider for inclusion.


Hi Wolfram,

	since the code has not been changed, my opinion remains that it is fine 
and it should enter mainline.

Best regards,

	Claudio

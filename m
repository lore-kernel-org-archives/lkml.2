Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab1BNNO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:14:27 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55097 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab1BNNOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:14:24 -0500
Message-ID: <8CB9F2C8F75C4041B9F0691D209DDAFD@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>,
        "Kurt Van Dijck" <kurt.van.dijck@eia.be>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <m-watkins@ti.com>,
        <nsekhar@ti.com>, <sachi@mistralsolutions.com>,
        "open list:CAN NETWORK DRIVERS" <socketcan-core@lists.berlios.de>,
        "open list:CAN NETWORK DRIVERS" <netdev@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-10-git-send-email-subhasish@mistralsolutions.com> <20110211150602.GB373@e-circ.dyndns.org> <C1C4300CE90A406FBDA2388D5491FAD5@subhasishg> <4D58D854.5090503@grandegger.com> <1F33D30F9B2D47ECA80CEC807A6C0727@subhasishg> <4D58F77B.9080005@pengutronix.de>
In-Reply-To: <4D58F77B.9080005@pengutronix.de>
Subject: Re: [PATCH v2 09/13] can: pruss CAN driver.
Date: Mon, 14 Feb 2011 18:45:17 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The problem with the "all" implementation is that it hogs the ARM/DSP 
heavily and that's the reason why we specifically avoided this in our 
firmware design.
Hence, implementing this condition spoils the whole purpose of the PRU!!

--------------------------------------------------
From: "Marc Kleine-Budde" <mkl@pengutronix.de>
Sent: Monday, February 14, 2011 3:05 PM
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>; "Kurt Van Dijck" 
<kurt.van.dijck@eia.be>; <davinci-linux-open-source@linux.davincidsp.com>; 
<linux-arm-kernel@lists.infradead.org>; <m-watkins@ti.com>; 
<nsekhar@ti.com>; <sachi@mistralsolutions.com>; "open list:CAN NETWORK 
DRIVERS" <socketcan-core@lists.berlios.de>; "open list:CAN NETWORK DRIVERS" 
<netdev@vger.kernel.org>; "open list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 09/13] can: pruss CAN driver.

Hello,

On 02/14/2011 09:45 AM, Subhasish Ghosh wrote:
> That is correct, we receive only pre-programmed CAN ids and "all" or
> "range" implementation is not there in the PRU firmware.

I'd really like to see that you add a "all" implementation to the
firmware. Or even better use the standard id/mask approach.

cheers, Marc

-- 
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   | 


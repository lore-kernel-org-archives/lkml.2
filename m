Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab1BKPGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:06:11 -0500
Received: from gate.eia.be ([194.78.71.18]:26594 "EHLO mail.eia.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab1BKPGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:06:10 -0500
Date: Fri, 11 Feb 2011 16:06:02 +0100
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com, Wolfgang Grandegger <wg@grandegger.com>,
        "open list:CAN NETWORK DRIVERS" <socketcan-core@lists.berlios.de>,
        "open list:CAN NETWORK DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 09/13] can: pruss CAN driver.
Message-ID: <20110211150602.GB373@e-circ.dyndns.org>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
 <1297435892-28278-10-git-send-email-subhasish@mistralsolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1297435892-28278-10-git-send-email-subhasish@mistralsolutions.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Feb 2011 15:06:06.0440 (UTC) FILETIME=[3510E680:01CBC9FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 08:21:28PM +0530, Subhasish Ghosh wrote:
> +config DA8XX_PRU_CANID_MBX0
> +	hex "CANID for mailbox 0"
> +	depends on CAN_TI_DA8XX_PRU
> +	default "0x123"
> +	---help---
> +	Enter the CANID for mailbox 0
> +	Default value is set to 0x123, change this as required.
> +
> +config DA8XX_PRU_CANID_MBX1
> +	hex "CANID for mailbox 1"
> +	depends on CAN_TI_DA8XX_PRU
> +	default "0x123"
> +	 ---help---
> +	Enter the CANID for mailbox 1
> +	Default value is set to 0x123, change this as required.
> +
> +config DA8XX_PRU_CANID_MBX2
> +	hex "CANID for mailbox 2"
> +	depends on CAN_TI_DA8XX_PRU
> +	default "0x123"
> +	---help---
> +	Enter the CANID for mailbox 2
> +	Default value is set to 0x123, change this as required.
> +
> +config DA8XX_PRU_CANID_MBX3
> +	hex "CANID for mailbox 3"
> +	depends on CAN_TI_DA8XX_PRU
> +	default "0x123"
> +	---help---
> +	Enter the CANID for mailbox 3
> +	Default value is set to 0x123, change this as required.
> +
> +config DA8XX_PRU_CANID_MBX4
> +	hex "CANID for mailbox 4"
> +	depends on CAN_TI_DA8XX_PRU
> +	default "0x123"
> +	---help---
> +	Enter the CANID for mailbox 4
> +	Default value is set to 0x123, change this as required.
> +
> +config DA8XX_PRU_CANID_MBX5
> +	hex "CANID for mailbox 5"
> +	depends on CAN_TI_DA8XX_PRU
> +	default "0x123"
> +	---help---
> +	Enter the CANID for mailbox 5
> +	Default value is set to 0x123, change this as required.
> +
> +config DA8XX_PRU_CANID_MBX6
> +	hex "CANID for mailbox 6"
> +	depends on CAN_TI_DA8XX_PRU
> +	default "0x123"
> +	---help---
> +	Enter the CANID for mailbox 6
> +	Default value is set to 0x123, change this as required.
> +
> +config DA8XX_PRU_CANID_MBX7
> +	hex "CANID for mailbox 7"
> +	depends on CAN_TI_DA8XX_PRU
> +	default "0x123"
> +	---help---
> +	Enter the CANID for mailbox 7
> +	Default value is set to 0x123, change this as required.
Why is filling the mailboxes the job of kernel config?

Regards,
Kurt

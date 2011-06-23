Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab1FWHQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 03:16:43 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.25]:49969 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1FWHQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 03:16:42 -0400
Message-ID: <4E02E856.70007@ladisch.de>
Date: Thu, 23 Jun 2011 09:16:38 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pch_uart: Add MSI support
References: <4E02857C.1010304@dsn.okisemi.com> <1308812405-5245-1-git-send-email-alexander.stein@systec-electronic.com>
In-Reply-To: <1308812405-5245-1-git-send-email-alexander.stein@systec-electronic.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Stein wrote:
> +++ b/drivers/tty/serial/pch_uart.c
> @@ -1578,6 +1578,8 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
>  
> +	pci_enable_msi(pdev);

Pretty much every driver that tries this eventually ends up with
a blacklist of devices that don't implement MSI correctly.
Did you test this with all the models that are supported by this driver?


Regards,
Clemens

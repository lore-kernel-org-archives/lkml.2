Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab1KAMrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:47:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:45306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab1KAMrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:47:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,438,1315206000"; 
   d="scan'208";a="84781303"
Date: Tue, 1 Nov 2011 12:57:57 +0000
From: Alan Cox <alan@linux.intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 2/2] pch_uart: Delete modem status interrupt enable code
Message-ID: <20111101125757.4ef7f883@bob.linux.org.uk>
In-Reply-To: <1319697919-5623-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1319697919-5623-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
	<1319697919-5623-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (pch_uart device has auto hardware flow control function. So,
> pch_uart driver doesn't have to control modem status interrupt.)

This is true for flow control bits but not for incoming carrier detect ?

> This patch deletes the code.

> +	dev_info(priv->port.dev,
> +		"PCH UART : Modem status interrupt is not
> supported.\n"); }

dev_info seems wrong here. Does the user need to know this ?

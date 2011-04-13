Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab1DMWPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:15:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:50265 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933068Ab1DMWPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:15:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,207,1301900400"; 
   d="scan'208";a="628194945"
Date: Wed, 13 Apr 2011 22:58:18 +0100
From: Alan Cox <alan@linux.intel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] atmel_serial: keep the platform_device unchanged
Message-ID: <20110413225818.39ce5104@bob.linux.org.uk>
In-Reply-To: <1302724038-26236-1-git-send-email-plagnioj@jcrosoft.com>
References: <1302724038-26236-1-git-send-email-plagnioj@jcrosoft.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 21:47:18 +0200
Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> wrote:

> specify the port num via platform_data this will allow to match the
> clock with the plaform_dev staticly
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD
> <plagnioj@jcrosoft.com> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Patrice Vilchez <patrice.vilchez@atmel.com>
> Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Ack for the serial side, its really an arch patch though as far as I
can see..

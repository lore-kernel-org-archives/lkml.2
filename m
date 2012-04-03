Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750950Ab2DCEAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 00:00:14 -0400
Received: from imr4.ericy.com ([198.24.6.9]:43933 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab2DCEAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 00:00:12 -0400
Date: Mon, 2 Apr 2012 20:57:16 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Rudolf Marek <r.marek@assembler.cz>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] hwmon: use module_pci_driver
Message-ID: <20120403035716.GA8682@ericsson.com>
References: <1333416346.18133.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1333416346.18133.4.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 09:25:46PM -0400, Axel Lin wrote:
> This patch converts the drivers in drivers/hwmon/* to use module_pci_driver()
> macro which makes the code smaller and a bit simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
> Cc: Clemens Ladisch <clemens@ladisch.de>
> Cc: Rudolf Marek <r.marek@assembler.cz>
> ---
>  drivers/hwmon/fam15h_power.c |   13 +------------
>  drivers/hwmon/k10temp.c      |   13 +------------
>  drivers/hwmon/k8temp.c       |   13 +------------
>  3 files changed, 3 insertions(+), 36 deletions(-)
> 
Applied.

Thanks,
Guenter

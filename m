Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068Ab1D2PXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:23:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35548 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab1D2PX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:23:29 -0400
Message-ID: <4DBAD7E8.8090703@ti.com>
Date: Fri, 29 Apr 2011 16:23:20 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: "grant@secretlab.ca" <grant@secretlab.ca>
CC: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv5 2/4] TPS65910: GPIO: Add GPIO driver
References: <2CAE1D41-48DC-457F-8FF3-E45B17AC3E0F@slimlogic.co.uk>
In-Reply-To: <2CAE1D41-48DC-457F-8FF3-E45B17AC3E0F@slimlogic.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/04/11 16:51, Jorge Eduardo Candelaria wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
> 
> TPS65910 has one configurable GPIO that can be used for several
> purposes. Subsequent versions of the TPS chip support more than
> one GPIO.
> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> ---
>  drivers/mfd/Makefile         |    2 +-
>  drivers/mfd/tps65910-gpio.c  |   91 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/tps65910.c       |    7 +++
>  include/linux/mfd/tps65910.h |    2 +
>  4 files changed, 101 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/mfd/tps65910-gpio.c
> 

Grant, if you are happy with this I can take all via regulator.

Liam

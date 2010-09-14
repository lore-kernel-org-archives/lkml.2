Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab0INHzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:55:09 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:18701 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab0INHzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:55:05 -0400
Date: Tue, 14 Sep 2010 09:54:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Yong Wang <yong.y.wang@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
        Kalhan Trisal <kalhan.trisal@intel.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon/emc1403: remove unnecessary 
 hwmon_device_unregister
Message-ID: <20100914095452.0d28a221@hyperion.delvare>
In-Reply-To: <20100914032211.GA3497@ericsson.com>
References: <20100914023351.GA27145@ywang-moblin2.bj.intel.com>
	<20100914032211.GA3497@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 20:22:11 -0700, Guenter Roeck wrote:
> On Mon, Sep 13, 2010 at 10:33:51PM -0400, Yong Wang wrote:
> > It is unnecessary to call hwmon_device_unregister in error handling
> > before hwmon_device_register is called.
> > 
> Not only unnecessary but wrong. Good catch.
> 
> > Signed-off-by: Yong Wang <yong.y.wang@intel.com>
> 
> Reviewed-by: Guenter Roeck <guenter.roeck@ericsson.com>

Applied, thanks.

-- 
Jean Delvare

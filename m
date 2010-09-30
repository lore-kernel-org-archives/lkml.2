Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab0I3Stw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 14:49:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35807
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab0I3Stv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 14:49:51 -0400
Date: Thu, 30 Sep 2010 11:50:10 -0700 (PDT)
Message-Id: <20100930.115010.45893999.davem@davemloft.net>
To: wg@grandegger.com
Cc: masa-korg@dsn.okisemi.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, meego-dev@meego.com,
        andrew.chih.howe.khor@intel.com, qi.wang@intel.com,
        margie.foster@intel.com, yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        morinaga526@dsn.okisemi.com, joel.clark@intel.com
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CA4541F.5040804@grandegger.com>
References: <4C9C7C6F.1000003@dsn.okisemi.com>
	<4CA4541F.5040804@grandegger.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Grandegger <wg@grandegger.com>
Date: Thu, 30 Sep 2010 11:10:55 +0200

> On 09/24/2010 12:24 PM, Masayuki Ohtak wrote:
>> +};
>> +
>> +static struct can_bittiming_const pch_can_bittiming_const = {
>> +	.name = KBUILD_MODNAME,
> 
> Not sure what KBUILD_MODNAME is. Should be "pch_can", the name of the
> driver.

That's what KBUILD_MODNAME will be defined to when this gets
compiled :-)


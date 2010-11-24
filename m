Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab0KXQzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:55:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55393
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424Ab0KXQz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:55:29 -0500
Date: Wed, 24 Nov 2010 08:55:54 -0800 (PST)
Message-Id: <20101124.085554.193704043.davem@davemloft.net>
To: mkl@pengutronix.de
Cc: tomoya-linux@dsn.okisemi.com, wg@grandegger.com, w.sang@pengutronix.de,
        chripell@fsfe.org, 21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew.chih.howe.khor@intel.com,
        qi.wang@intel.com, margie.foster@intel.com, yong.y.wang@intel.com,
        kok.howg.ewe@intel.com, joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 1/17 v2] can: EG20T PCH: Separate
 Interface Register(IF1/IF2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CECEC85.1050009@pengutronix.de>
References: <4CECBFE3.8030402@dsn.okisemi.com>
	<4CECEC85.1050009@pengutronix.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Wed, 24 Nov 2010 11:44:21 +0100

> On 11/24/2010 08:33 AM, Tomoya MORINAGA wrote:
>> Separate interface register from whole of register structure.
>> CAN register of Intel PCH EG20T has 2 sets of interface register.
>> To reduce whole of code size, separate interface register.
>> As a result, the number of function also can be reduced.
> 
> I failed to apply your series to david's net-2.6/master. Please resubmit.

It applies to net-next-2.6 since that is where I applied his previous
two patches.

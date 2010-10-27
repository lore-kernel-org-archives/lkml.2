Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0J0Hau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 03:30:50 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:33827 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab0J0Has (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 03:30:48 -0400
X-Auth-Info: iaTNN45N7kN0cOL4ig8UT3Cu4H1GMjDWUTr2KYoYEcY=
Message-ID: <4CC7D566.7090707@grandegger.com>
Date: Wed, 27 Oct 2010 09:31:50 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        socketcan-core@lists.berlios.de, sameo@linux.intel.com,
        21cnbao@gmail.com, chripell@fsfe.org, w.sang@pengutronix.de,
        andrew.chih.howe.khor@intel.com, qi.wang@intel.com,
        margie.foster@intel.com, yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        David Miller <davem@davemloft.net>, joel.clark@intel.com
Subject: Re: can: About Socket CAN with MSI issue
References: <4CC61B1B.3090602@dsn.okisemi.com>	<20101026.105206.15244527.davem@davemloft.net> <002801cb758f$876aaf00$66f8800a@maildom.okisemi.com>
In-Reply-To: <002801cb758f$876aaf00$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 06:29 AM, Tomoya MORINAGA wrote:
> We have faced issue when our CAN diriver whose MSI is enabled, after installing the driver,
> once remove the driver and install the driver again,
> As a result, interupt handler of the driver is not called again.
> 
> Do you have any information or suggestion about the above issue?

Not really, the remove functions looks ok, apart from the fact, that
pch_can_reset() is called *after* pci_iounmap().

Wolfgang.

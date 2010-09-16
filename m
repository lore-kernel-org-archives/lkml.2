Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0IPJKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 05:10:14 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:52807 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0IPJKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 05:10:12 -0400
X-Auth-Info: ddEjgzXO+N/M8RhGyjYzJToLn62gsVEvHgrGAZzGDOk=
Message-ID: <4C91DF20.7040807@grandegger.com>
Date: Thu, 16 Sep 2010 11:10:56 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
CC: Marc Kleine-Budde <mkl@pengutronix.de>, arjan@linux.intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>, yong.y.wang@intel.com,
        gregkh@suse.de, qi.wang@intel.com, andrew.chih.howe.khor@intel.com,
        meego-dev@meego.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, socketcan-core@lists.berlios.de,
        Samuel Ortiz <sameo@linux.intel.com>, Barry Song <21cnbao@gmail.com>,
        Christian Pellegrin <chripell@fsfe.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [MeeGo-Dev][PATCH v2] Topcliff: Update PCH_CAN driver to 2.6.35
References: <4C8E1773.9090000@dsn.okisemi.com> <4C8E3FDE.2000002@pengutronix.de> <002601cb557c$69292180$66f8800a@maildom.okisemi.com>
In-Reply-To: <002601cb557c$69292180$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2010 10:51 AM, Masayuki Ohtake wrote:
> Hi Marc,
> 
>> - Please remove rx-filter handling from the driver completely, simply
>>   receive every can frame
> 
> This rx-filter function is for Topcliff's CAN HW function.
> This function is important.
> Could you tell us the reason why should we remove filter function ?

We do not (yet) support the filtering capability of the CAN controller
hardware. Therefore please configure the hardware filter to accept *any*
CAN message like all other drivers do, e.g.:

http://lxr.linux.no/#linux+v2.6.35.4/drivers/net/can/sja1000/sja1000.c#L249

Wolfgang.

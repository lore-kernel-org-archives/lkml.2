Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0JAMkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:40:03 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:55011 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab0JAMkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:40:02 -0400
X-Auth-Info: 5+pmm3vFwOFy2QdDI13rMhFO7xVLIouLjlXyRtComdA=
Message-ID: <4CA5D6D7.3010608@grandegger.com>
Date: Fri, 01 Oct 2010 14:40:55 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
CC: andrew.chih.howe.khor@intel.com, qi.wang@intel.com,
        margie.foster@intel.com, netdev@vger.kernel.org, yong.y.wang@intel.com,
        linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de,
        kok.howg.ewe@intel.com, Christian Pellegrin <chripell@fsfe.org>,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>, meego-dev@meego.com,
        "David S. Miller" <davem@davemloft.net>, joel.clark@intel.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35
References: <4C9C7C6F.1000003@dsn.okisemi.com>	<4CA4541F.5040804@grandegger.com> <000401cb614f$c932c750$66f8800a@maildom.okisemi.com>
In-Reply-To: <000401cb614f$c932c750$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2010 12:02 PM, Masayuki Ohtake wrote:
> Hi Wolfgang Grandegger,
> 
> Thank you for your comments.
> 
> We will modify and re-post ASAP.
> 
> I have a comment about below.
>> In this driver you are using just *one* RX object. This means that the
>> CPU must handle new messages as quickly as possible otherwise message
>> losses will happen, right?. For sure, this will not make user's happy.
>> Any chance to use more RX objects in FIFO mode?
> 
> In case implementing with FIFO mode,
> received packets may be our of order.

Hm, FIFO means "First in First out"! It might be tricky to implement,
though.

> Because our CAN register access is slow.
> 
> I am confirming our CAN HW spec and the possibility of our-of-order.

I don't understand?

Wolfgang.


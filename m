Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab0I0Ihd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:37:33 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:54686 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab0I0Ihb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:37:31 -0400
X-Auth-Info: fnMF1u5NniGiyIrJ8d29HFy8/AVljX1DWa2xnxTomxk=
Message-ID: <4CA057FA.1000101@grandegger.com>
Date: Mon, 27 Sep 2010 10:38:18 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, meego-dev@meego.com,
        andrew.chih.howe.khor@intel.com, qi.wang@intel.com,
        margie.foster@intel.com, yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>, joel.clark@intel.com
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35
References: <4C9C7C6F.1000003@dsn.okisemi.com>
In-Reply-To: <4C9C7C6F.1000003@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohtake,

On 09/24/2010 12:24 PM, Masayuki Ohtak wrote:
> Hi Wolfgang and Marc,
> 
> We have modified a pretty amount of our driver based on other accepted Socket CAN driver.
> Additionally, We have reduced the number of lines 3601 to 1444.

Much better now! I need some more time for a full review, though.

Thanks,

Wolfgang.

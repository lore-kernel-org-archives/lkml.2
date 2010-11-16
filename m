Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268Ab0KPLDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:03:32 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:39859 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044Ab0KPLDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:03:30 -0500
X-Auth-Info: 1HAoPBlKn2t3rZXDBKH0s93HQjHWpOfw2qnUVmBZ45I=
Message-ID: <4CE2654B.20004@grandegger.com>
Date: Tue, 16 Nov 2010 12:04:43 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew.chih.howe.khor@intel.com,
        qi.wang@intel.com, margie.foster@intel.com, yong.y.wang@intel.com,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 v3] can: Topcliff: PCH_CAN driver: Add Flow
 control,
References: <4CE2434B.5050701@dsn.okisemi.com>
In-Reply-To: <4CE2434B.5050701@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomoya,

On 11/16/2010 09:39 AM, Tomoya MORINAGA wrote:
> Hi Marc and Wolf,
> 
> I have updated your indications.
> 
>> * Add Flow control
>> * Fix Data copy issue (endianness)
>> * Add Macro prefix "PCH_"
>> * Separate interface register structure
>> * Some functions are unified.
>> * Change MessageObject indication(PCH_RX_OBJ_START, etc..)
>> * Enumerate LEC macro
>> * Move MSI processing from open/close to probe/remove processing
>> * Use BIT(x)
>> * and more...
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Could you please resend the patch (as v4) with a proper subject and
commit message. Then I will add my "Acked-by" to get that
*not-yet-ready* driver updated quickly.

Wolfgang.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab1GNSmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 14:42:14 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:19761 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab1GNSmM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 14:42:12 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-160.messagelabs.com!1310668916!28640802!28
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.32]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "wim@iguana.be" <wim@iguana.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tim.bird@am.sony.com" <tim.bird@am.sony.com>
Date: Thu, 14 Jul 2011 13:42:02 -0500
Subject: RE: [RFC 0/6] watchdog drivers converted to the new framework
Thread-Topic: [RFC 0/6] watchdog drivers converted to the new framework
Thread-Index: AcxCU7W61vf29pq8QraOqxRSOBEzBAAAd26A
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F383E05BCD@AUSP01VMBX24.collaborationhost.net>
References: <1310588766-16638-1-git-send-email-w.sang@pengutronix.de>
 <ADE657CA350FB648AAC2C43247A983F001F383E05B65@AUSP01VMBX24.collaborationhost.net>
 <20110714182734.GA31082@pengutronix.de>
In-Reply-To: <20110714182734.GA31082@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 14, 2011 11:28 AM, Wolfram Sang wrote:
>> I would also like to convert this driver into a proper platform_driver using
>> ioremap'ed addresses instead of the static mappings.  Converting the driver
>> to the new watchdog framework would make this a bit cleaner.
>
> Try managed devices (devm_* and friends) for an extra cleanup bonus.

Already done, just waiting for the framework... ;-)

Regards,
Hartley
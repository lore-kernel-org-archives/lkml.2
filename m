Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab2IRAkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 20:40:32 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:60118 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754799Ab2IRAka convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 20:40:30 -0400
From: Mirko Lindner <mlindner@marvell.com>
To: Jiri Pirko <jiri@resnulli.us>, Stephen Hemminger <shemminger@vyatta.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 17 Sep 2012 17:38:52 -0700
Subject: RE: [patch net] sky2: fix rx filter setup on link up
Thread-Topic: [patch net] sky2: fix rx filter setup on link up
Thread-Index: Ac2VFaga4rMqSuJLTcKBuB/UKdcQPQAH5F53
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE1B63898F0B@SC-VEXCH4.marvell.com>
References: <1347894617-13614-1-git-send-email-jiri@resnulli.us>
 <20120917091214.5cd9b0f5@nehalam.linuxnetplumber.net>,<20120917204724.GA1749@minipsycho.orion>
In-Reply-To: <20120917204724.GA1749@minipsycho.orion>
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

>Mon, Sep 17, 2012 at 06:12:14PM CEST, shemminger@vyatta.com wrote:
>>On Mon, 17 Sep 2012 17:10:17 +0200
>>Jiri Pirko <jiri@resnulli.us> wrote:
>>
>>> In my case I have following problem. sky2_set_multicast() sets registers
>>> GM_MC_ADDR_H[1-4] correctly to:
>>> 0000 0800 0001 0410
>>> However, when adapter gets link and sky2_link_up() is called, the values
>>> are for some reason different:
>>> 0000 0800 0016 0410
>>
>>Rather than papering over the problem, it would be better to
>>trace back what is setting those registers and fix that code.

>Yes, I did that. No code at sky2.[ch] is writing to this registers other
>than sky2_set_multicast() and sky2_gmac_reset() (I hooked on sky2_write*()).
>So I strongly believe this is a HW issue (maybe only issue of my revision
>"Yukon-2 EC chip revision 2")

I would like to check the registers as soon as I'm back in my office next week and report my findings.
Could you also please check the hint from Stephen?
Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab0FCRbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:31:47 -0400
Received: from avexcashub1.qlogic.com ([198.70.193.61]:55433 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab0FCRbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:31:45 -0400
From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Driver <Linux-Driver@qlogic.com>
Date: Thu, 3 Jun 2010 10:31:40 -0700
Subject: Re: linux-next: Tree for June 3 (qlcnic)
Thread-Topic: linux-next: Tree for June 3 (qlcnic)
Thread-Index: AcsDQqMNdEYJUl7SSN6WIa9ZgcBfsg==
Message-ID: <4A3D4210-F6CF-4D74-A21A-F6AA4A287445@qlogic.com>
References: <20100603134753.710a64b3.sfr@canb.auug.org.au>
 <20100603084618.387a39fa.randy.dunlap@oracle.com>
In-Reply-To: <20100603084618.387a39fa.randy.dunlap@oracle.com>
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


On Jun 3, 2010, at 8:46 AM, Randy Dunlap wrote:

> On Thu, 3 Jun 2010 13:47:53 +1000 Stephen Rothwell wrote:
> 
>> Hi all,
>> 
>> Changes since 20100602:
> 
> 
> when CONFIG_INET=n:
> 
> ERROR: "qlcnicvf_set_ilb_mode" [drivers/net/qlcnic/qlcnic.ko] undefined!
> ERROR: "qlcnicvf_config_bridged_mode" [drivers/net/qlcnic/qlcnic.ko] undefined!
> ERROR: "qlcnicvf_config_led" [drivers/net/qlcnic/qlcnic.ko] undefined!
> ERROR: "qlcnicvf_clear_ilb_mode" [drivers/net/qlcnic/qlcnic.ko] undefined!
> ERROR: "qlcnicvf_start_firmware" [drivers/net/qlcnic/qlcnic.ko] undefined!
> 
> full config is attached.
> 

Sorry about that. I will send fix right away.

thanks,
Anirban


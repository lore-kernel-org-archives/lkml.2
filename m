Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1EaCFC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 22:05:02 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:53082 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751662Ab1EaCFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 22:05:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAE1M5E1Ld/sX/2dsb2JhbAAMR4RJ1h2QQoErg2yBBwSYD4d2
X-IronPort-AV: E=Sophos;i="4.65,295,1304308800"; 
   d="scan'208";a="115006171"
Message-ID: <4DE44CCA.20608@teksavvy.com>
Date: Mon, 30 May 2011 22:04:58 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Bruce Stenning <b.stenning@indigovision.com>
CC: Tejun Heo <htejun@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
References: <20110423005610.GC1576@mtj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C775549E4@gretna.indigovision.com> <20110425162242.GB30828@mtj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C77554BDC@gretna.indigovision.com> <20110426135027.GI878@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C77554C70@gretna.indigovision.com> <20110426155229.GM878@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C77554C91@gretna.indigovision.com> <20110430140109.GJ29280@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C777089B2@gretna.indigovision.com> <20110525094127.GF10146@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C7770967B@gretna.indigovision.com> <4DDD823F.5090904@teksavvy.com> <C1438B59050E1B4C9482FF3266AD6BA32C7777DD92@gretna.indigovision.com>
In-Reply-To: <C1438B59050E1B4C9482FF3266AD6BA32C7777DD92@gretna.indigovision.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-05-30 09:07 AM, Bruce Stenning wrote:
>>> Mark, did you get a chance to clean up the sata_mv spinlock addition in
>>> mv_set_main_irq_mask?
>>
>> Not yet.  I've been waiting to hear back from you as to
>> whether they visibly fix anything or not.
> 
> Having now tested with Tejun's two patches and without the spinlock in
> mv_set_main_irq_mask for a reasonable time, the hotplug seems to be very
> reliable.  So I think it's probably best to leave the spinlock out and
> continue to observe the behaviour with further testing.

Peachy.  I'll have another look at some point -- I think I thought
the spinlock was still needed for ATAPI under some conditions.
Gotta look closer to make sure.

Thanks.

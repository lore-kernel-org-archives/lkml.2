Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab0HICdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 22:33:22 -0400
Received: from mamba.crocodile.org ([216.218.215.112]:43829 "EHLO
	periplum.crocodile.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752917Ab0HICdV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 22:33:21 -0400
X-Greylist: delayed 4041 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Aug 2010 22:33:21 EDT
References: <E64899AA-23A5-49D7-8C91-B94A095290E0@crocodile.org> <1268034117.3819.1.camel@jlt3.sipsolutions.net> <36779F26-DB1B-46ED-8635-01B03E559B55@crocodile.org> <20100310062227.GB2445@core.coreip.homeip.net> <87k4o234lx.fsf@depni.sinp.msu.ru> <1281196050.4431.4.camel@jlt3.sipsolutions.net> <1281313223.2168.46.camel@pasglop>
In-Reply-To: <1281313223.2168.46.camel@pasglop>
Mime-Version: 1.0 (iPhone Mail 8A306)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <9D74DA20-E3C8-43BC-B529-82605F64637F@crocodile.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8A306)
From: Vadim Zaliva <lord@crocodile.org>
Subject: Re: [PATCH 1/1] integer overflow issue in 'appletouch' driver
Date: Sun, 8 Aug 2010 18:24:39 -0700
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tested the patch on device I had       
I will have an access to it to retest later thus week. We can wait for my test to try to identify how my PowerBook is different from yours. Or you can roll the patch back. 

--
Sent from my iPhone

On Aug 8, 2010, at 17:20, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
>>> My device is 05ac:020e "fountain", actually generates *signed* values,
>>> thus the patch completely breaks it.
>> 
>> I think Ben might have the same issue. I guess we need per-touchpad
>> functions to read the data.
> 
> Yup, I confirm, same deal. This patch completely breaks it on my
> powerbook (same USB ID)
> 
> Should we revert the commit for now ?
> 
> Cheers,
> Ben.
> 

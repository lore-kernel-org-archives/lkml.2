Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab2CIKfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 05:35:12 -0500
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:59760 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751375Ab2CIKfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 05:35:10 -0500
Date: Fri, 9 Mar 2012 10:58:34 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Axel Lin <axel.lin@gmail.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH v10] Regulator: Add Anatop regulator driver
Message-ID: <20120309095834.GM27213@game.jcrosoft.org>
References: <1331200744-5986-1-git-send-email-paul.liu@linaro.org>
 <20120308141847.GG27213@game.jcrosoft.org>
 <4F59B899.2080704@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F59B899.2080704@linaro.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 15481686670081829862
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrfeduucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggugfgjfgesthektfdttderje
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrfeduucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggugfgjfgesthektfdttderje
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:00 Fri 09 Mar     , Ying-Chun Liu (PaulLiu) wrote:
> (2012年03月08日 22:18), Jean-Christophe PLAGNIOL-VILLARD wrote:
> >> +static int __devexit anatop_regulator_remove(struct platform_device *pdev)
> >> +{
> >> +	struct regulator_dev *rdev = platform_get_drvdata(pdev);
> >> +	struct anatop_regulator *sreg = rdev_get_drvdata(rdev);
> >> +	kfree(sreg->name);
> >> +	regulator_unregister(rdev);
> > return from the unregister
> >> +	return 0;
> >> +}
> > Best Regards,
> > J.
> 
> Hi Jean-Christophe,
> 
> I've modify the patch based on your review. However, the last one cannot
> be made because regulator_unregister is void return.
so we have a issue here regulator_unregister MUST return an error conde

Best Regards,
J.

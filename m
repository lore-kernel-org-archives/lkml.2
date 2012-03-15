Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658Ab2COPxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:53:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49287 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761118Ab2COPxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:53:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9] mfd: Add anatop mfd driver
Date: Thu, 15 Mar 2012 15:52:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linaro-dev@lists.linaro.org, Samuel Ortiz <sameo@linux.intel.com>,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        "Ying-Chun Liu \(PaulLiu\)" <paul.liu@linaro.org>
References: <1331797421-23731-1-git-send-email-paul.liu@linaro.org> <201203150907.29895.arnd@arndb.de> <20120315120948.GG3138@opensource.wolfsonmicro.com>
In-Reply-To: <20120315120948.GG3138@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203151552.54617.arnd@arndb.de>
X-Provags-ID: V02:K0:OrQ0CwKXyJD0ngvK3XmB0BZXNYJ2QrBpE3cMeCy+48p
 U1Qhin5kBKbP4Wc17DWm2EE4Aa5KkKKJrlVoM30PHzoEeQIrWx
 ZHauGIbsatda6q5K+97xK2VV8YWzOsn5r20ZCXeVwQMp7LgYoN
 fjyJxNdopk6zGCrRaf8ABygmoDCWGD8CKLiDoGW58giIaC8221
 Ag00FQMeWpMbY/mf8R5Idx3x9xPvQheaCi+wHQnnyI2YQffdAJ
 z+g1Q4llHqk16x0KkNGpU4apDOkkivHu+MenAlyoSQWfGHfSEf
 GEtUTloqlHB4hQe+XPD7x6TFjgNjxRnlr74LlGX30fy66F+5Oa
 H3Kgs6vvKIZ8WnPKlub0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 March 2012, Mark Brown wrote:
> There were some other mutterings about using regmap for memory mapped
> devices, mostly from the point of view of building framework features
> like this on top of it.  regmap currently makes some assumptions that
> the I/O is going to be slow so approximately any amount of CPU time can
> usefully be spent on avoiding I/O but we can probably do something about
> that.  It also uses mutexes to lock I/O which might not be the most
> sensible thing for memory mapped devices, but again that's solveable.
> Right now there's no memory mapping support but there's no reason that
> can't be added.
> 
> In short, it does seem sensible to want to have some support for this
> for devices that use appropriate idioms.

Ok, I see. 

I guess there is no reason to change anything in Paul's patch now, but
we can keep this in mind if we see a lot of similar drivers in the future.

Thanks,

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab1KHKXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 05:23:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43136 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471Ab1KHKXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 05:23:10 -0500
Date: Tue, 8 Nov 2011 10:23:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "cbou@mail.ru" <cbou@mail.ru>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>
Subject: Re: [Patch 04/11]Power: DA9052 battery driver v4
Message-ID: <20111108102307.GA25591@opensource.wolfsonmicro.com>
References: <1319033916.17688.41.camel@dhruva>
 <1320742364.9320.2.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320742364.9320.2.camel@dhruva>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 02:22:44PM +0530, Ashish Jangam wrote:
> On Wed, 2011-10-19 at 19:48 +0530, Ashish Jangam wrote:
> > Driver for DA9052 battery charger. This driver depends on DA9052 MFD core dirver
> > for definitions and methods.
> > 
> > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > ---
> In case there are no review comments then can this be get ACK'ed?

The last time you posted this there was a serious issues with the MFD
core which meant it didn't seem worth reviewing.

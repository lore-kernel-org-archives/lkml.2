Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1LLEse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 23:48:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44971 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127Ab1LLEsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 23:48:31 -0500
Date: Mon, 12 Dec 2011 12:48:27 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        linaro-dev@lists.linaro.org, arnd@arndb.de, eric.miao@linaro.org
Subject: Re: [PATCH 01/06] MFD: DA9052/53 MFD core module v9
Message-ID: <20111212044826.GC2806@opensource.wolfsonmicro.com>
References: <1323440144.23171.69.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323440144.23171.69.camel@dhruva>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 07:45:44PM +0530, Ashish Jangam wrote:
> The DA9052/53 is a highly integrated PMIC subsystem with supply domain
> flexibility to support wide range of high performance application.

Oh, actually I see you didn't Samuel, you must always CC maintainers on
patches otherwise they're likely to not see and apply them.

Samuel, as this uses a newly introduced regmap feature do you want me to
apply these patches?  I'm also happy for you to merge 

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git topic/irq

into your tree (though obviously that'd prevent you rebasing).

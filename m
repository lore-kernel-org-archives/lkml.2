Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2DSOV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 10:21:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53389 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab2DSOVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 10:21:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2 0/8] Second patchset for LPC32xx device tree conversion
Date: Thu, 19 Apr 2012 14:21:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Roland Stigge <stigge@antcom.de>,
        devel@driverdev.osuosl.org, srinivas.bakki@nxp.com,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, marek.vasut@gmail.com, arm@kernel.org,
        linux-input@vger.kernel.org, axel.lin@gmail.com,
        dmitry.torokhov@gmail.com, linux-arm-kernel@lists.infradead.org
References: <1334682507-15055-1-git-send-email-stigge@antcom.de> <201204181100.40123.arnd@arndb.de> <20120418165650.GD3099@opensource.wolfsonmicro.com>
In-Reply-To: <20120418165650.GD3099@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204191421.29558.arnd@arndb.de>
X-Provags-ID: V02:K0:7tD/GXDAiAMHNhQIUCQ2k8tcA0t7syqDvC+RHhD4yga
 3PydItmgrbW9ezyeo/wdGN2LiGIwZVLJD3um6PsBPXwUa5R3hp
 4F6x0q7VMg0/qlPrrr1AqmERL4xI5tICOcjb+4Iz01p5o4cmwJ
 QcTVhQBnalyL8NDkbJ0zSqOlTPqABAiZ5rcQozvRLxZ4D9HLyl
 +pqdPHbSs3PuhBaI+jnfi65yA651Vn9Kh+Aq/OFNitHtEJ9Qv0
 8Ecyzp46fLLwrxUvIyxigUCKMKMN8//Lty3MajxBYQvNYRXhgm
 EKLAc5rjXIWQcxq/YkybQ5E5ExrTpT/xo+Sw6uaEhS7Z4u28rM
 YWS0ynaFSH20AqrrYgPg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 April 2012, Mark Brown wrote:
> On Wed, Apr 18, 2012 at 11:00:39AM +0000, Arnd Bergmann wrote:
> 
> > 1. develop on -rc
> > 2. merge with latest -next, test and make sure it works there
> > 3. submit for review against -rc
> > 4. have patches included in -next once reviewed, but based on -rc
> > 5. when merge window opens, have patches sent for upstream inclusion
> 
> Steps 3 and 4 should be to submit against whatever branch is appropriate
> for the subsystem and driver - if people follow this process they're
> going to get bounced back by a fair proportion of maintainers, -rc isn't
> universally what people are looking for so people should be aware that
> they need to pay attention here.  
> 
> Generally I'd say the development version is a safer bet than -rc for
> most subsystems.

Right. The description above was mostly done for the lpc32xx case,
which is going to get merged through the arm-soc tree and that doesn't
have a single development branch but instead has lots of them.

For subsystems that have just one branch, I agree that it makes sense
to develop against that one. Also for arm-soc, it can make sense
to base on one of the existing branches, but I prefer the default
to be to base on the -rc release so I can mix and match incoming
branches as needed.

	Arnd

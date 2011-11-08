Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1KHKjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 05:39:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47084 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751192Ab1KHKjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 05:39:41 -0500
Date: Tue, 8 Nov 2011 10:39:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Takashi Iwai <tiwai@suse.de>, perex@perex.cz, linux-kernel@vger.kernel.org,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Clark, Joel" <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] Add SoundCard driver for OKI SEMICONDUCTOR ML7213 IOH
Message-ID: <20111108103939.GB25591@opensource.wolfsonmicro.com>
References: <70D251FDDC55405882A8447CC455D56E@hacdom.okisemi.com>
 <8486F61FC3B94B908BFE654234DD6C97@hacdom.okisemi.com>
 <4E9BAEF7.1080406@dsn.lapis-semi.com>
 <s5h7h3ysa4l.wl%tiwai@suse.de>
 <4EA5563A.10703@dsn.lapis-semi.com>
 <20111024122015.GA26033@opensource.wolfsonmicro.com>
 <4EB8F079.9080703@dsn.lapis-semi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB8F079.9080703@dsn.lapis-semi.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 06:03:53PM +0900, Tomoya MORINAGA wrote:

> Though roughly, we re-created 3 files codec driver, platform drive
> and machine driver. (Not debugged/tested)
> Could you check these files ?

Please send patches for review using the standard kernel review process
- see Documentation/SubmittingPatches.  Sending a single enormous review
makes it much more difficult for people to review as there's so much
code in the one mail and attachments don't work with people's normal
workflows.

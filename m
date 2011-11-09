Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1KIC40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 21:56:26 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:37153 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756Ab1KIC4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 21:56:25 -0500
Message-ID: <4EB9EBD7.5060700@dsn.lapis-semi.com>
Date: Wed, 09 Nov 2011 11:56:23 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Takashi Iwai <tiwai@suse.de>, perex@perex.cz, linux-kernel@vger.kernel.org,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Clark, Joel" <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] Add SoundCard driver for OKI SEMICONDUCTOR ML7213 IOH
References: <70D251FDDC55405882A8447CC455D56E@hacdom.okisemi.com> <8486F61FC3B94B908BFE654234DD6C97@hacdom.okisemi.com> <4E9BAEF7.1080406@dsn.lapis-semi.com> <s5h7h3ysa4l.wl%tiwai@suse.de> <4EA5563A.10703@dsn.lapis-semi.com> <20111024122015.GA26033@opensource.wolfsonmicro.com> <4EB8F079.9080703@dsn.lapis-semi.com> <20111108103939.GB25591@opensource.wolfsonmicro.com>
In-Reply-To: <20111108103939.GB25591@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/11/08 19:39), Mark Brown wrote:
> On Tue, Nov 08, 2011 at 06:03:53PM +0900, Tomoya MORINAGA wrote:
>
>> Though roughly, we re-created 3 files codec driver, platform drive
>> and machine driver. (Not debugged/tested)
>> Could you check these files ?
>
> Please send patches for review using the standard kernel review process
> - see Documentation/SubmittingPatches.  Sending a single enormous review
> makes it much more difficult for people to review as there's so much
> code in the one mail and attachments don't work with people's normal
> workflows.
>
OK, I will post our patches.

Thanks,
-- 
tomoya
ROHM Co., Ltd.

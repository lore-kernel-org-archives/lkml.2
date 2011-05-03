Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165Ab1ECHYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 03:24:51 -0400
Received: from a.relay.invitel.net ([62.77.203.3]:46287 "EHLO
	a.relay.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1ECHYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 03:24:50 -0400
Date: Tue, 03 May 2011 09:24:46 +0200
From: Heiko Schocher <hs@denx.de>
Subject: Re: [PATCH v6 0/6] powerpc, 52xx: add charon board support
In-reply-to: <BANLkTimacM29RHExZounuziF+7jARQxdTg@mail.gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linuxppc-dev@lists.ozlabs.org, Wolfram Sang <w.sang@pengutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@ozlabs.org,
        Ben Dooks <ben@simtec.co.uk>, Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Wolfgang Denk <wd@denx.de>,
        Paul Mundt <lethal@linux-sh.org>
Reply-to: hs@denx.de
Message-id: <4DBFADBE.5040603@denx.de>
Organization: DENX Software Engineering
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1300782452-528-1-git-send-email-hs@denx.de>
 <20110502221406.GA15043@ponder.secretlab.ca> <4DBF8FF6.8030100@denx.de>
 <BANLkTimacM29RHExZounuziF+7jARQxdTg@mail.gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Grant,

Grant Likely wrote:
> On Mon, May 2, 2011 at 11:17 PM, Heiko Schocher <hs@denx.de> wrote:
>> Hello Grant,
>>
>> Grant Likely wrote:
>>> On Tue, Mar 22, 2011 at 09:27:26AM +0100, Heiko Schocher wrote:
>>>> cc: Wolfram Sang <w.sang@pengutronix.de>
>>>> cc: Grant Likely <grant.likely@secretlab.ca>
>>>> cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>>> cc: linux-fbdev@vger.kernel.org
>>>> cc: devicetree-discuss@ozlabs.org
>>>> cc: Ben Dooks <ben@simtec.co.uk>
>>>> cc: Vincent Sanders <vince@simtec.co.uk>
>>>> cc: Samuel Ortiz <sameo@linux.intel.com>
>>>> cc: linux-kernel@vger.kernel.org
>>>> cc: Randy Dunlap <rdunlap@xenotime.net>
>>>> cc: Wolfgang Denk <wd@denx.de>
>>>> cc: Paul Mundt <lethal@linux-sh.org>
>>>>
>>>> changes since v5:
>>>> - repost complete patchseries, as Paul Mundt suggested
>>>> - rebased against current head
>>>> - add Acked-by from Samuel Ortiz (MFD parts)
>>>>   http://www.spinics.net/lists/linux-fbdev/msg02550.html
>>>>   http://linux.derkeiler.com/Mailing-Lists/Kernel/2011-01/msg11798.html
>>>>
>>>>   and Benjamin Herrenschmidt (DTS parts)
>>>>   http://lists.ozlabs.org/pipermail/linuxppc-dev/2011-February/088279.html
>>>> - removed patch
>>>>   "powerpc, mpc5200: update mpc5200_defconfig to fit for charon board."
>>>>   therefore added
>>>>   "powerpc, tqm5200: update tqm5200_defconfig to fit for charon board."
>>> Refresh my memory, why was the mpc5200_defconfig updated dropped?
>> Because it is a board based on the tqm5200 board port ... no other
>> reason.
> 
> Please send a patch to also update the mpc5200_defconfig.

Ok. Done, just one more question:

Why you didn;t pick up the patches:

- powerpc, 5200: add support for charon board
  (Got an Acked-by from Wolfram Sang)
- powerpc, video: add SM501 support for charon board.

Are there any issues with them, I should fix?

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

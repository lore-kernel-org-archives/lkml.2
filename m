Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab1CQGNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 02:13:15 -0400
Received: from a.relay.invitel.net ([62.77.203.3]:57126 "EHLO
	a.relay.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab1CQGNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 02:13:10 -0400
Date: Thu, 17 Mar 2011 07:12:56 +0100
From: Heiko Schocher <hs@denx.de>
Subject: Re: [PATCH 3/4 v5] video, sm501: add OF binding to support SM501
In-reply-to: <20110316153601.GA13315@linux-sh.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Wolfgang Denk <wd@denx.de>
Reply-to: hs@denx.de
Message-id: <4D81A668.8060500@denx.de>
Organization: DENX Software Engineering
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1296026490-14665-1-git-send-email-hs@denx.de> <4D7F14B0.1030008@denx.de>
 <20110316153601.GA13315@linux-sh.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul,

Paul Mundt schrieb:
> On Tue, Mar 15, 2011 at 08:26:40AM +0100, Heiko Schocher wrote:
>>> 0003-video-sm501-add-OF-binding-to-support-SM501.patch has no obvious style problems and is ready for submission.
>>>
>>>  Documentation/powerpc/dts-bindings/sm501.txt |   34 +++++++++++++++++++++
>>>  drivers/mfd/sm501.c                          |    9 +++++-
>>>  drivers/video/sm501fb.c                      |   42 ++++++++++++++++++++++++--
>>>  3 files changed, 81 insertions(+), 4 deletions(-)
>>>  create mode 100644 Documentation/powerpc/dts-bindings/sm501.txt
>> This patchset is pending know for a while. I got Acked by from
>>
>> Samuel Ortiz for the mfd part, see here:
>>
>> http://www.spinics.net/lists/linux-fbdev/msg02550.html
>> http://linux.derkeiler.com/Mailing-Lists/Kernel/2011-01/msg11798.html
>>
>> and for the DTS part from Benjamin Herrenschmidt:
>>
>> http://lists.ozlabs.org/pipermail/linuxppc-dev/2011-February/088279.html
>>
>> Are there some more issues?
>>
> Not that I remember off the top of my head, but I think they've been lost
> in my backlog. Could you re-send the current series with the appropriate
> acked-bys? If there's nothing else obvious outstanding I'll roll them in.

Ok, I resend them (I also rebase them to current tree, ok?)

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

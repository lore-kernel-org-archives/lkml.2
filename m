Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab0JKHsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 03:48:55 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:59997 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325Ab0JKHsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 03:48:53 -0400
Message-ID: <4CB2C154.5060303@euromail.se>
Date: Mon, 11 Oct 2010 09:48:36 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, xorg-devel@lists.x.org,
        Chris Bagwell <chris@cnpbagwell.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Duncan McGreggor <duncan.mcgreggor@canonical.com>
Subject: Re: [PATCH 0/3] Input: synaptics - multitouch and multifinger support
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com>	<s5hfwwg4p4t.wl%tiwai@suse.de>	<1286558135.22715.162.camel@mini>	<201010081104.01527.dmitry.torokhov@gmail.com>	<s5h62xc4h2l.wl%tiwai@suse.de>	<20101010210434.GC18455@core.coreip.homeip.net> <s5hy6a52ndd.wl%tiwai@suse.de>
In-Reply-To: <s5hy6a52ndd.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1P5D7f-0005vA-5H.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1P5D7f-0005vA-5H 72288632a982052ba8939a319a81a34c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2010 09:35 AM, Takashi Iwai wrote:
[...]

> In anyway, feel free to add my sign-off there since I already posted
> my own one as a reference.
> 
> But, I have an open issue with Chase's patch.  Maybe it's rather a
> question to Henrik:
> 
> Shouldn't all points be reported as ABS_MT_* events?  So far, only the
> second touch-point is reported via ABS_MT_* while the first  point is
> still reported as ABX_[X|Y].
> 
> I corrected this in my patch I posted, but I wasn't sure, too.


I have issues with all submitted patches, but did not give explicit reasons
since there were overlapping submissions. Perhaps Chase and yourself can work
out how you want to submit the new patches? And yes, all points should be
reported as ABS_MT events.

Thanks,
Henrik

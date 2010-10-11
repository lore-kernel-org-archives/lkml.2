Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab0JKHkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 03:40:40 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:39374 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760Ab0JKHki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 03:40:38 -0400
Message-ID: <4CB2BF68.80302@euromail.se>
Date: Mon, 11 Oct 2010 09:40:24 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Input: synaptics - multitouch and multifinger support
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com>	<s5hfwwg4p4t.wl%tiwai@suse.de>	<4CB17019.7070002@euromail.se>	<20101010205932.GB18455@core.coreip.homeip.net> <s5hzkul2np1.wl%tiwai@suse.de>
In-Reply-To: <s5hzkul2np1.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1P5Czj-0003Iq-5e.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1P5Czj-0003Iq-5e 9f2f73cc5093a50fb9cf305904f7e8cb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2010 09:28 AM, Takashi Iwai wrote:
[...]

> Right, but it's pretty hard to know whether it works really for all
> machines, simply because the current MT-detection is nothing but a
> pure guess work.  As mentioned in another mail, there are devices that
> have no this bit but reports multi-finger detections without
> tracking.  So, there are definitely other things to be checked.
> 
> Thus, I'm inclined to add a module option, at least, for *disabling*
> MT for non-working machines.  Also, another question is whether it's
> safe to enable MT even for user-space that don't understand MT.


Yes, you can add MT support on top of the ST protocol of an existing driver.

Henrik

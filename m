Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0HSXft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 19:35:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36302 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab0HSXfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 19:35:46 -0400
Date: Fri, 20 Aug 2010 00:35:32 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Neil Leeder <nleeder@codeaurora.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Trilok Soni <tsoni@codeaurora.org>
Subject: Re: [PATCH v2] input: mouse: add qci touchpad driver
Message-ID: <20100819233532.GB21662@srcf.ucam.org>
References: <1281631760-15589-1-git-send-email-nleeder@codeaurora.org> <20100813024912.GA2661@core.coreip.homeip.net> <4C65BF99.9030601@codeaurora.org> <201008131754.49488.dmitry.torokhov@gmail.com> <4C6AC393.8000109@codeaurora.org> <BC741E3E-377E-45BF-80E1-A60F4E0FDFC9@gmail.com> <4C6C52DE.4040700@codeaurora.org> <20100819053311.GE5832@core.coreip.homeip.net> <4C6DADDE.7030107@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6DADDE.7030107@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 06:19:10PM -0400, Neil Leeder wrote:

> At this point I'm thinking that the interface is close to being able to  
> work with serio/psmouse, but just not close enough. The unreliability of  
> responding to basic commands as well as the length of data problems  
> indicates some custom driver is going to be needed. That could either be  
> Quanta's original touchpad driver I posted, or a modification of your  
> serio driver. I'd lean towards not having a serio driver which includes  
> workarounds for a specific device, but I'd appreciate hearing your 
> opinion.

By any incredible stroke of luck, does it have a unique PNPID? 
/sys/bus/pnp/devices/*/id should give you some insight.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

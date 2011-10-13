Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab1JMS2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:28:55 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:36488 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755854Ab1JMS2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:28:53 -0400
Message-ID: <4E972DE1.9020308@xenotime.net>
Date: Thu, 13 Oct 2011 11:28:49 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] linux-next: Tree for Oct 12 (sound/soc/codecs/wm1250-ev1)
References: <20111012175425.a2e3e6e6a92265e433aeca25@canb.auug.org.au> <4E9634C9.3020404@xenotime.net> <20111013102427.GG1098@sirena.org.uk>
In-Reply-To: <20111013102427.GG1098@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 03:24 AM, Mark Brown wrote:
> On Wed, Oct 12, 2011 at 05:46:01PM -0700, Randy Dunlap wrote:
> 
>> When no GPIO kconfig options are enabled:
>> (not GPIOLIB, not GENERIC_GPIO):
> 
> As ever the consumer side GPIO API is supposed to stub itself out when
> not in use.

You are listed as MODULE_AUTHOR().  Can we expect a fix?

I don't see how stubs help with source lines like:
struct wm1250_priv {
	struct gpio gpios[WM1250_EV1_NUM_GPIOS];
};

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

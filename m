Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab2IFALb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:11:31 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:39813 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760011Ab2IFAL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:11:29 -0400
Message-ID: <5047EA1C.7080608@xenotime.net>
Date: Wed, 05 Sep 2012 17:11:08 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: Re: [PATCH -next] soc: fix wm0010.c printk format warning
References: <20120905161230.3bab1de6d4c8c8e466c3b0df@canb.auug.org.au> <5047DF49.6070502@xenotime.net> <20120906000612.GO10580@opensource.wolfsonmicro.com>
In-Reply-To: <20120906000612.GO10580@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 05:06 PM, Mark Brown wrote:

> On Wed, Sep 05, 2012 at 04:24:57PM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> Fix printk format warning:
> 
> Somone already sent this.  As ever please try to use subject lines
> appropriate for the subsystem.  Please also consider who you're CCing -


Unfortunately the MAINTAINERS file does not tell me what to include
in the $subject line for the subsystem.
What would you like to see there, please?  Maybe ASoC?

> there's no need to copy -next on things like this which aren't


I have always done a reply-to-all for linux-next patches, so after
a few years someone days Don't Do That (IYO).

> integration issues for example, if we start doing that then it'd get
> drowned in noise from all the development.


Agreed, many of us are already drowning from 1000+ emails per day.
(seriously)

-- 
~Randy

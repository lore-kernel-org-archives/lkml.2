Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031138Ab1EXBW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:22:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28122 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031105Ab1EXBW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:22:26 -0400
Message-ID: <4DDB082F.3010107@oracle.com>
Date: Mon, 23 May 2011 18:21:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: x86@kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        alsa-devel@alsa-project.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Harald Welte <laforge@gnufiish.org>,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: linux-next: Tree for May 23 (sound/soc/codecs)
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au> <20110523134815.fb87933a.randy.dunlap@oracle.com> <20110523224659.GB19533@opensource.wolfsonmicro.com> <20110523155343.2e68c265.randy.dunlap@oracle.com> <20110524000837.GA30515@opensource.wolfsonmicro.com>
In-Reply-To: <20110524000837.GA30515@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DDB083E.00BF:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/11 17:08, Mark Brown wrote:
> On Mon, May 23, 2011 at 03:53:43PM -0700, Randy Dunlap wrote:
>> On Tue, 24 May 2011 06:47:28 +0800 Mark Brown wrote:
> 
>>> case, please talk to the architecture maintainers about this - it's an
>>> issue in the architecture GPIO support (or lack thereof) rather than a
>>> driver problem.
> 
>> except that a driver should not assume that defines like
>> GPIOF_OUT_INIT_LOW are always available.
> 
> No, really we should.  The GPIO APIs are stubbed out when not in use for
> a very good reason, think about the usability here.  The goal here isn't
> to litter the code with ifdefs - if architectures aren't able to keep up
> with API changes they should convert to using gpiolib so this stuff
> happens automatically (indeed, I can't think of any good reason for an
> architecture to not be using gpiolib at this point).

No, I would say that there are a lot of drivers in sound/soc/codecs/
that are missing some GPIO pieces in the Kconfig file.

>>> Also adding Dmitry who submitted the driver - Randy, please try to
>>> remember to CC relevant people.
> 
>> Which driver did Dmitry submit?  how would I know that?
>> I don't download every linux-next git tree -- just linux-next tarballs.
> 
> I *strongly* suggest looking at git if you want to find relevant people
> to mail; the internal documentation in the code really isn't a terribly
> useful guide, the authors listed in the code often bear no relation to
> who's actually working on it at the current time.
> 
>> and wm8915.c says:
>> MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
> 
> You've clearly not looked at MAINTAINERS for this one.

It's not listed in the MAINTAINERS file.
But maybe you mean scripts/get_maintainer.pl, which I did try.
I found that using git log <that source file name> was better info
than using scripts/get_maintainer.pl.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

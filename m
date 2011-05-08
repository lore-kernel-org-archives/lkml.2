Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab1EHPiw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:38:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34960 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab1EHPiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:38:50 -0400
Message-ID: <4DC6B8F7.4000302@oracle.com>
Date: Sun, 08 May 2011 08:38:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] soc: fix wm8958-dsp2 printk format warnings
References: <20110505134959.b3761297.sfr@canb.auug.org.au> <20110506161310.54b22b9f.randy.dunlap@oracle.com> <20110508140101.GB15968@opensource.wolfsonmicro.com>
In-Reply-To: <20110508140101.GB15968@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4DC6B903.0022:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/11 07:01, Mark Brown wrote:
> On Fri, May 06, 2011 at 04:13:10PM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix printk format warnings in wm8958-dsp2.c:
> 
> Please do try to follow the standard patch submission process:
> 
> - Send patches to maintainers.
> - Send patches to the relevant mailing lists.
> - Use the relevant subsystem prefix in your commit message.

OK, I will note this and save this email for future reference.

Do I need to resend the patch?

What subsystem prefix do you want to see there?  from MAINTAINERS file:
SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT (ASoC)

thanks,
-- 
~Randy

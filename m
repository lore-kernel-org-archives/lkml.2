Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1FOR7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 13:59:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51456 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab1FOR7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 13:59:33 -0400
Message-ID: <4DF8F2E5.4090705@oracle.com>
Date: Wed, 15 Jun 2011 10:59:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Dmitry Artamonow <mad_soft@inbox.ru>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, Harald Welte <laforge@gnufiish.org>
Subject: Re: [PATCH 2/2] gpio: include linux/gpio.h where needed
References: <4DDB3AFF.9030006@oracle.com>	<20110524075248.GB19734@sirena.org.uk>	<20110527074552.GA907@ponder.secretlab.ca>	<4DDFE391.2030507@oracle.com>	<20110527201201.GA6645@ponder.secretlab.ca>	<BANLkTin-KSVcG2cQfRM3Ys0_g_uJVruDMw@mail.gmail.com>	<20110603171837.GA9918@opensource.wolfsonmicro.com>	<BANLkTi=oko_C8_46Y8p5O1Qvw1KEn-1PjA@mail.gmail.com>	<4DEC4D67.6010506@oracle.com>	<20110614091211.465553de.randy.dunlap@oracle.com>	<20110614161357.GB1839@ponder.secretlab.ca>	<20110614170602.7a51b1af.randy.dunlap@oracle.com> <20110615103420.1578eb5c.sfr@canb.auug.org.au>
In-Reply-To: <20110615103420.1578eb5c.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DF8F2F6.0046:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/11 17:34, Stephen Rothwell wrote:
> Hi Randy,
> 
> On Tue, 14 Jun 2011 17:06:02 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Some files use GPIOF_ macros but don't include the header file
>> for them.  These macros are being moved to <linux/gpio.h>, so add
>> includes for <linux/gpio.h> where needed.
> 
> Shouldn't these patches be in the other order to avoid bisection problems?

Hm, I suppose so.

Grant, can you apply these with patch 2/2 first or do I need to resend
the patches?

thanks,
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

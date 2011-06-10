Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1FJDFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:05:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61618 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1FJDF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:05:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fOl5S+y2mWrgCAvcj9bvs4qigY3QsHwXT7Q4IEs0kweiSgYlwckC4+V0QcvAh5fTmM
         Lsgoy3sQk7msPu2WYcSRbNA9HhzgBySDDdG/mO6+oMDBViRfFTkzEc3GzkSBm8F2v01e
         9psoSFqqGAjU01FrHra/dPt8jmTc/EzRvVizU=
Message-ID: <4DF189F2.3040009@gmail.com>
Date: Fri, 10 Jun 2011 13:05:22 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: linux-kernel@vger.kernel.org, Andre Renaud <andre@bluewatersys.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <avictor.za@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, trivial@kernel.org
Subject: Re: [PATCH trival/tree-wide] Change Ryan Mallon's email address across
 the kernel
References: <1307661170-9325-1-git-send-email-rmallon@gmail.com> <20110610025532.GE26006@linux-sh.org>
In-Reply-To: <20110610025532.GE26006@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/11 12:55, Paul Mundt wrote:
> On Fri, Jun 10, 2011 at 09:12:50AM +1000, Ryan Mallon wrote:
>> I no longer work at Bluewater Systems. Update my email address accordingly.
>>
> Is this sort of churn really necessary? By all means, update your
> MAINTAINERS entry accordingly, but the rest of it is really pretty
> pointless. People are invariably going to consult MAINTAINERS one way or
> another and get the updated value accordingly. For the rest of these you
> are just as well off ripping out the email address completely.
The MAINTAINERS entry for me only cover the arm ep93xx arch. Prior to 
this patch, if I do (for example)

./scripts/get_maintainer.pl -f drivers/power/ds2782_battery.c

It gives my old Bluewater email. With this change it gives my gmail 
account. Not sure if that is because it extracts the email from the 
source or from the git commit? Either way, the patch gets the correct 
behaviour for people who send patches using get_maintainer.

~Ryan


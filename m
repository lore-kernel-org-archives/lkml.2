Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab0IVPY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:24:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47036 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab0IVPY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:24:57 -0400
Message-ID: <4C9A1FB7.9050902@oracle.com>
Date: Wed, 22 Sep 2010 08:24:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Any SYSRQ key to force mode switch to console mode when using
 KMS?
References: <19601.1301.803816.92851@elektron.ikp.physik.tu-darmstadt.de>	<20100921151033.80e61747.randy.dunlap@oracle.com> <19609.53242.674915.369484@elektron.ikp.physik.tu-darmstadt.de>
In-Reply-To: <19609.53242.674915.369484@elektron.ikp.physik.tu-darmstadt.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/10 02:44, Uwe Bonnes wrote:
>>>>>> "Randy" == Randy Dunlap <randy.dunlap@oracle.com> writes:
> 
>     Randy> On Wed, 15 Sep 2010 19:40:37 +0200 Uwe Bonnes wrote:
>     >> Hello,
>     >> 
>     >> is there any SYSRQ key that forces the video system to console mode,
>     >> especially when using KMS and allows to work on.
> 
>     Randy> sysrq-v help message says:
> 
>     Randy> force-fb(V) = "Restore framebuffer console"
> 
> How is that documented outside the sysrq itself?
> 
> /usr/src/linux-2.6.36-rc4-19/Documentation/sysrq.txt:
> 
> 'v'     - Dumps Voyager SMP processor info to your console

Yes, I noticed that and I posted a patch for it yesterday.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

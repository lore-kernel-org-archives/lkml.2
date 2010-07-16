Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965614Ab0GPNZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 09:25:36 -0400
Received: from ottmail.xandros.com ([142.46.212.35]:46379 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965564Ab0GPNZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 09:25:35 -0400
Date: Fri, 16 Jul 2010 09:27:28 -0400
From: Woody Suwalski <terraluna977@gmail.com>
To: Martin Michlmayr <tbm@cyrius.com>
cc: Lee Jones <lee.jones@canonical.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <4C405E40.7040606@gmail.com>
In-Reply-To: <20100716093744.GN11238@jirafa.cyrius.com>
References: <4C3C72C6.4000005@canonical.com>
References: <20100715130214.4c9303b2.akpm@linux-foundation.org>
References: <20100715200618.GA6773@n2100.arm.linux.org.uk>
References: <4C40218A.4090806@canonical.com>
References: <20100716093744.GN11238@jirafa.cyrius.com>
Subject: Re: [PATCH] Stop ARM boards crashing when CUPS is loaded - 2.6.35-rc5
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SeaMonkey/2.0.4
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Michlmayr wrote:
> * Lee Jones<lee.jones@canonical.com>  [2010-07-16 10:08]:
>    
>>>> That sounds like a pretty serious problem.  But presumably it isn't -
>>>> otherwise it would have been fixed earlier!
>>>>          
>> Well it is a problem on OMAP based boards.
>>      
> It's not just OMAP.  Debian received a similar bug report a few days
> too and it was on Marvell Orion hardware.  I simply disabled the
> parport_pc module on ARM.
>
>    
That works for you because Debian no longer supports Netwinders 8-(

Woody


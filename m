Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965203Ab0GPLMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 07:12:22 -0400
Received: from adelie.canonical.com ([91.189.90.139]:47009 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965153Ab0GPLMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 07:12:15 -0400
Message-ID: <4C403E87.4040503@canonical.com>
Date: Fri, 16 Jul 2010 12:12:07 +0100
From: Lee Jones <lee.jones@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>, gregkh@suse.de
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@canonical.com>
Subject: Re: [PATCH] Stop ARM boards crashing when CUPS is loaded -	2.6.35-rc5
References: <4C3C72C6.4000005@canonical.com>	<20100715130214.4c9303b2.akpm@linux-foundation.org>	<20100715200618.GA6773@n2100.arm.linux.org.uk>	<4C40218A.4090806@canonical.com>	<20100716092018.GB16995@n2100.arm.linux.org.uk> <4C402746.6080309@canonical.com>
In-Reply-To: <4C402746.6080309@canonical.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/10 10:32, Lee Jones wrote:
>> The best solution is probably for the parport code to go through a
>> modernisation cycle like the serial code did, essentially using
>> platform devices to pass the base addresses.  This would make the
>> driver more portable, and eliminates this problem entirely (because
>> platforms which don't have parports won't register the platform device(s)
>> necessary for parport to even probe illegal addresses.)

I have lobbied for one of our partners to conduct this work, but I don't
think this would be something that is in their interest to fix. 
Nevertheless, I am currently waiting on a reply from them.

FAO GregKH,

Do you think this would be something that may interest you and your Linux 
drivers project? Or perhaps a student who wants to get their feet wet and
play with some platform driver code.

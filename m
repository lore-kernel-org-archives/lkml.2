Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422944Ab2CPPTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:19:35 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46756 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032894Ab2CPPTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:19:32 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.129.58]
In-Reply-To: <20120315171359.GA7276@atomide.com>
References: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
	<1331829845-9526-3-git-send-email-j-pihet@ti.com>
	<20120315171359.GA7276@atomide.com>
Date: Fri, 16 Mar 2012 16:19:31 +0100
Message-ID: <CAORVsuUp9VBX1XbkQkcq91XsbRSut1RC6KCNPFHrX+RfWv7hQA@mail.gmail.com>
Subject: Re: [PATCH 02/10] ARM: OMAP2+: SmartReflex: move the platform
 specific macros in plat-omap
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, Jean Pihet <j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Thu, Mar 15, 2012 at 6:14 PM, Tony Lindgren <tony@atomide.com> wrote:
> * jean.pihet@newoldbits.com <jean.pihet@newoldbits.com> [120315 09:47]:
>> From: Jean Pihet <j-pihet@ti.com>
>>
>> Move the platform specific macros from the smartreflex header file
>> (arch/arm/mach-omap2/smartreflex.h) in a new header file in plat-omap
>> (arch/arm/plat-omap/include/plat/smartreflex.h).
>>
>> This change makes the SmartReflex implementation ready for the move
>> to drivers/.
>
> Glad to see this happening!
>
> This would be better located in linux/power/smartreflex.h rather than
> plat/smartreflex.h.
Ok. Is the file name still Ok in that case? Should it mention OMAP?

Thanks,
Jean

>
> Regards,
>
> Tony

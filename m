Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab2L0XjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:39:21 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:34065 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab2L0XjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:39:19 -0500
X-Remote-IP: 213.191.128.133
Date: Fri, 28 Dec 2012 00:39:13 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
References: <CA+icZUV_CdAvq1nmOVZeLSAu0mZj+BO0T++REc6U1hevt50hXA@mail.gmail.com>
In-Reply-To: <CA+icZUV_CdAvq1nmOVZeLSAu0mZj+BO0T++REc6U1hevt50hXA@mail.gmail.com>
Message-ID: <50DCDC21.6080303@iskon.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 0000000000000500
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20121227 #8899382, check: 20121227 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 40794 [Dec 28 2012]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.12.2012 00:30, Sedat Dilek wrote:
> Hi Zlatko,
>
> I am not sure if I hit the same problem as described in this thread.
>
> Under heavy load, while building a customized toolchain for the Freetz
> router project I got a BUG || NULL pointer derefence || kswapd ||
> zone_balanced || pgdat_balanced() etc. (details see my screenshot).
>
> I will try your patch from [1] ***only*** on top of my last
> Linux-v3.8-rc1 GIT setup (post-v3.8-rc1 mainline + some net-fixes).
>

Yes, that's the same bug. It should be fixed with my latest patch, so 
I'd appreciate you testing it, to be on the safe side this time. There 
should be no difference if you apply it to anything newer than 3.8-rc1, 
so go for it. Thanks!

Regards,
-- 
Zlatko

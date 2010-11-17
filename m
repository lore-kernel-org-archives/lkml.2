Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451Ab0KQFoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:44:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45716 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab0KQFoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:44:17 -0500
Message-ID: <4CE36B8B.3040403@zytor.com>
Date: Tue, 16 Nov 2010 21:43:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Alex Gershgorin <agersh@rambler.ru>, Indan Zupancic <indan@nul.nu>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il> <4CE0FE71.6000303@suse.cz> <20101115100838.GA3649@jasper.tkos.co.il> <4CE10B32.8090705@suse.cz> <c30e46c1b5343789b6475722071c3020.squirrel@webmail.greenhost.nl> <20101116110444.2f0cabd9@lxorguk.ukuu.org.uk> <4CE28299.30907@suse.cz> <20101117053251.GA26928@jasper.tkos.co.il>
In-Reply-To: <20101117053251.GA26928@jasper.tkos.co.il>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 09:32 PM, Baruch Siach wrote:
> Hi Jiri, Alan,
> 
> On Tue, Nov 16, 2010 at 02:09:45PM +0100, Jiri Slaby wrote:
>> On 11/16/2010 12:04 PM, Alan Cox wrote:
>>> Sixteen devices is way too many for drivers/misc - it only has 256 total
>>> and only half of those are dynamic.
>>
>> Seconded. (And it's a quarter, not even a half like I already wrote.)
> 
> If I reduce the maximal number of devices to 4, will it make any difference? I 
> don't mind even having a limit of 2 by default, as long as a simple define 
> change is enough to raise this limit.
> 
Just use a major.  No biggie.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


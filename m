Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435Ab0KPHnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:43:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50895 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab0KPHnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 02:43:13 -0500
Message-ID: <4CE235EE.3040602@zytor.com>
Date: Mon, 15 Nov 2010 23:42:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: Indan Zupancic <indan@nul.nu>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il> <4CE0FE71.6000303@suse.cz> <20101115100838.GA3649@jasper.tkos.co.il> <4CE10B32.8090705@suse.cz> <c30e46c1b5343789b6475722071c3020.squirrel@webmail.greenhost.nl> <20101116055602.GA18210@jasper.tkos.co.il>
In-Reply-To: <20101116055602.GA18210@jasper.tkos.co.il>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 09:56 PM, Baruch Siach wrote:
>>
>> This is niche enough, don't make it more complicated than needed.
>> Having its own major seems overkill.
> 
> I agree.
> 

Numbers are cheap, especially these days when we have 12-bit dynamic
majors.  Of course, we also have 20-bit dynamic minors.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


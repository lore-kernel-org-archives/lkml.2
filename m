Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1EMCu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 22:50:28 -0400
Received: from 75.98.165.80.static.a2webhosting.com ([75.98.165.80]:46800 "EHLO
	greenroomsoftware.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1EMCuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 22:50:18 -0400
Message-ID: <4DCC9C5F.2000301@greenroomsoftware.com>
Date: Thu, 12 May 2011 19:50:07 -0700
From: Robert Gordon <robert@greenroomsoftware.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Nuno Subtil <subtil@gmail.com>
CC: maximilian attems <max@stro.at>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] deb-pkg: fix cross-compile build
References: <1304488750-13606-1-git-send-email-subtil@gmail.com> <20110504204807.GB13293@sepie.suse.cz> <20110505090728.GC30678@vostochny.stro.at> <4DC2C568.9090803@greenroomsoftware.com> <BANLkTinjBun=TzjveEiJsEJYKH_+NRCP7Q@mail.gmail.com> <4DC2EB2B.1050203@greenroomsoftware.com> <BANLkTimApO4j-Hsvo2OCc=PnEdOhHu76OA@mail.gmail.com> <20110510124123.GE13278@vostochny.stro.at> <4DCBE83C.2080403@greenroomsoftware.com> <BANLkTi=e62Whz+jyW-MtCN-nYGwUUBR6sg@mail.gmail.com>
In-Reply-To: <BANLkTi=e62Whz+jyW-MtCN-nYGwUUBR6sg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s60.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - greenroomsoftware.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/12/11 12:45 PM, Nuno Subtil wrote:
>> The debian/control file for an unpatched scripts/package/builddeb would
>> assign 'i386' instead of 'amd64'.
>
> That seems wrong to me. Were the resulting packages actually usable on amd64?

I modeled my patch after behavior I saw in the unpatched script.  I had 
also originally set x86_64 to amd64 with the exact results I get with 
your patch.  So, I looked at what the unpatched kernel was doing, which 
is putting i386 in those fields when building for x86_64 on an i386 
machine.  I don't know the results would actually run because I don't 
have an x86_64 myself.  It may not run, but it does build.

cheers!


-- 
*www.greenroomsoftware.com*

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965413Ab1C3WEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:04:45 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:56426 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933410Ab1C3WEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:04:43 -0400
Message-ID: <4D93A8F9.2080407@msgid.tls.msk.ru>
Date: Thu, 31 Mar 2011 02:04:41 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mijinlong@cn.fujitsu.com, ak@linux.intel.com, bfields@redhat.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: Re: [PATCH] [232/275] nfsd: wrong index used in inner loop
References: <20110330203.501921634@firstfloor.org> <20110330210757.F3D223E1A05@tassilo.jf.intel.com> <4D93A6F4.60206@msgid.tls.msk.ru>
In-Reply-To: <4D93A6F4.60206@msgid.tls.msk.ru>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

31.03.2011 01:56, Michael Tokarev пишет:
> 31.03.2011 01:07, Andi Kleen wrote:
>> 2.6.35-longterm review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>> From: Mi Jinlong <mijinlong@cn.fujitsu.com>
>>
>> commit 5a02ab7c3c4580f94d13c683721039855b67cda6 upstream.
>>
>> We must not use dummy for index.
>> After the first index, READ32(dummy) will change dummy!!!!
> 
> This is also in patch 180/275 (this one is 232/275).

Doh, so this 232/275 basically reverts that 180 and makes
other change down the line, but keeps the subject intact.
Especially useful that the two patches are so far away
from each other (more than 50 patches in-between).
Confusing :)

So both are actually needed, apparently.

Thanks!

/mjt


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab1AMOaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:30:22 -0500
Received: from 27.mail-out.ovh.net ([91.121.30.210]:41219 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751194Ab1AMOaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:30:21 -0500
Message-ID: <4D2F0C64.3010403@example.com>
Date: Thu, 13 Jan 2011 15:29:56 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error in linux-2.6.37-git5 in btrfs in ctree.c
References: <4D2C52E3.2020702@example.com> <20110111131423.GA17312@hack> <4D2DB674.4030900@example.com>
In-Reply-To: <4D2DB674.4030900@example.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 893401577159618930
X-Ovh-Remote: 83.24.79.110 (dmx110.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.01.2011 15:11, Piotr Hosowicz wrote:
> On 11.01.2011 14:14, Américo Wang wrote:
>> On Tue, Jan 11, 2011 at 01:53:55PM +0100, Piotr Hosowicz wrote:
>>> (I send again because my previous message wasn't delivered.)
>>>
>>> Hello,
>>>
>>> There is an error in here:
>>>
>>> In file included from fs/btrfs/ctree.c:21:
>>> fs/btrfs/ctree.h:1003: error: field ‘super_kobj’ has incomplete type
>>> fs/btrfs/ctree.h:1074: error: field ‘root_kobj’ has incomplete type
>>>
>>> Kernel fails to build. linux-2.6.37-git5
>
> I see that it's the same in Linus GIT tree, I didn't fail to build,
> because I corrected the same way first, it's building now. Should it be
> like that?
>

The situation is exactly the same today. What to do? I don't need btrfs, 
but must do some correction s I do not understand exactly. I don't like it.

Regards,

Piotr Hosowicz



-- 
Janusz Korwin-Mikke:
"Dyktatury dzielą się na dobre i złe. Demokracja jest zawsze głupia."
NP:  -
NB: 2.6.37-20110113-1411-pztidm+

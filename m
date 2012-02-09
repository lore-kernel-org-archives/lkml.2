Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab2BIP6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:58:48 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:50000 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753128Ab2BIP6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:58:47 -0500
Message-ID: <4F33ED21.1070604@xenotime.net>
Date: Thu, 09 Feb 2012 07:58:25 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Don Zickus <dzickus@redhat.com>,
        =?ISO-8859-1?Q?Fernando_Luis_V=E1?= =?ISO-8859-1?Q?zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: update documentation
References: <4F323B21.7080003@oss.ntt.co.jp> <20120208184337.GU5650@redhat.com> <20120209074335.GA18387@elte.hu>
In-Reply-To: <20120209074335.GA18387@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 11:43 PM, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
>> On Wed, Feb 08, 2012 at 06:06:41PM +0900, Fernando Luis Vázquez Cao wrote:
>>> The soft and hard lockup detectors are now built on top of the hrtimer
>>> and perf subsystems. Update the documentation accordingly.
>>
>>> Subject: [PATCH] watchdog: update documentation
>>>
>>> From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
>>>
>>> The soft and hard lockup detectors are now built on top of the hrtimer
>>> and perf subsystems. Update the documentation accordingly.
>>
>> I am fine with this (just need to address Randy's little 
>> fixup).
>>
>> Ingo, should I take this in and repost for you or just ack it 
>> and let someone like Andrew take this in?
> 
> Yeah, would be nice to have it with Randy's ack and your 
> signoff, can apply it then.

updated patch:
Acked-by: Randy Dunlap <rdunlap@xenotime.net>

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

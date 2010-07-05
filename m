Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0GFAJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 20:09:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51934 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab0GFAJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 20:09:09 -0400
Message-ID: <4C323CAD.1070602@zytor.com>
Date: Mon, 05 Jul 2010 13:12:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, Ian Kent <raven@themaw.net>,
       linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>, autofs@linux.kernel.org
Subject: Re: [PATCH 3/6] autofs/autofs4: move compat_ioctl handling into fs
References: <1278195310-25590-1-git-send-email-arnd@arndb.de> <4C3235C3.7050303@zytor.com> <20100705194759.GE5240@nowhere> <201007052152.55954.arnd@arndb.de> <20100705195837.GF5240@nowhere>
In-Reply-To: <20100705195837.GF5240@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 12:58 PM, Frederic Weisbecker wrote:
> On Mon, Jul 05, 2010 at 09:52:55PM +0200, Arnd Bergmann wrote:
>> On Monday 05 July 2010 21:48:01 Frederic Weisbecker wrote:
>>> On Mon, Jul 05, 2010 at 12:42:59PM -0700, H. Peter Anvin wrote:
>>>> On 07/05/2010 12:24 PM, Frederic Weisbecker wrote:
>>>>>
>>>>> Peter, if you're fine with this version. May I apply it?
>>>>> Unless you have a tree for autofs.
>>>>>
>>>> Ian Kent is the maintainer of autofs4 and patches for autofs4 should go
>>>> through him (or acked by him.)
>>>>
>>>> autofs 3 is officially unmaintained; I'm more than happy to have you
>>>> push the autofs 3 bits of this patch.
>>>
>>> Sure, I can split up the patch and integrate the autofs 3 part, I'll send
>>> the standalone autofs4 version to Ian.
>>
>> I think in this case it's really more appropriate to change both autofs3
>> and autofs4 together, to avoid interdependencies. Whichever way Ian
>> prefers (ack the patch or take it) would work though.
>>
>> 	Arnd
> 
> 
> Yeah indeed. Ian?
> 

For what it's worth, feel free to add my:

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2BVKUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:20:39 -0500
Received: from mail.neratec.ch ([80.75.119.105]:46390 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab2BVKUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:20:37 -0500
X-Greylist: delayed 757 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Feb 2012 05:20:37 EST
Message-ID: <4F44BE7B.8000501@neratec.com>
Date: Wed, 22 Feb 2012 11:07:55 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: andrei.emeltchenko.news@gmail.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-02-20
References: <20120221151435.GA19354@tuxdriver.com>	<20120221.144417.1445117001833888214.davem@davemloft.net>	<CAMXE1-qB8_5oGey2=Ypa5BitZnye3YqdM=yB8oKCGLvoZu_8HQ@mail.gmail.com> <20120221.154053.2103818562080068513.davem@davemloft.net>
In-Reply-To: <20120221.154053.2103818562080068513.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 09:40 PM, David Miller wrote:
> From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
> Date: Tue, 21 Feb 2012 22:38:16 +0200
> 
>> Hi David,
>>
>> On Tue, Feb 21, 2012 at 9:44 PM, David Miller <davem@davemloft.net> wrote:
>>> From: "John W. Linville" <linville@tuxdriver.com>
>>> Date: Tue, 21 Feb 2012 10:14:36 -0500
>>> [...]
>>
>> Sorry did we understand wrong text of Linux coding style? Or do we need
>> right interpretation of it?
> 
> I'm not engaging in this conversation any more, I don't care what CodingStyle
> says, the quoted code is garbage.

This is not really helpful, David.

Andrei's question was fully reasonable here, i.e. the Documentation/CodingStyle is the only binding reference given to potential contributors -- the common 'how-to-contribute-kernel-patches' docs non-24/7-kernel-folks usually find and follow on the way preparing patches end exactly there.

I recently learned the hard way when my patches were ignored just because of some missing spaces. That would be perfectly fair if some formal rules were broken, but not telling people about additional informal ones is not motivating.


I might be fully blind and just missed the related coding style document that covers the issues discussed here. But even then your answer should be 'RTFM' instead of just ending the conversation.


Cheers, Zefir

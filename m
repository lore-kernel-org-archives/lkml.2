Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0J0HN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 03:13:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65174 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab0J0HNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 03:13:25 -0400
Message-ID: <4CC7D0B0.3000303@ontolinux.com>
Date: Wed, 27 Oct 2010 09:11:44 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] fs: remove inode_lock from iput_final and prune_icache
References: <1288153384-8878-1-git-send-email-david@fromorbit.com>	 <1288153384-8878-5-git-send-email-david@fromorbit.com>	 <20101027044038.GE19804@ZenIV.linux.org.uk>	 <1288154866.2652.84.camel@edumazet-laptop>	 <20101027052520.GF19804@ZenIV.linux.org.uk> <1288158623.2652.161.camel@edumazet-laptop>
In-Reply-To: <1288158623.2652.161.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:FOyTw55PSl160GDXhFb9VRw+Bgi4PrH6LuQJhqC6ReE
 fzmfPAiIKSlnA8pB7yvLqojQv1GYunB/xfFaiT5iMn3JIDFpBi
 HY+PMJyIO3gqEyPipjhk1gak8zbcAFexwnnzpLChondwYve638
 jDDcLUbKWuSbwIGqgMKpSl3IiFHGGpZPQLYmluAaNbCdPoYzG2
 47xtmci6jg5eG+oQATlKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On the 27.10.2010 07:50, Eric Dumazet wrote :
> Le mercredi 27 octobre 2010 à 06:25 +0100, Al Viro a écrit :
>> "i\xe1\xb9\x89ode_lock", i.e. 'n' turned into U+1E49, aka "latin small letter
>> n with line below".  I doubt that it's MTA braindamage.
>>
>> In the first patch there's
>>
>> - * invalidate_inodes    - attempt to free all inodes on a
>> + * nvalidate_inodes    - attempt to free all inodes on a
>>
>> and I _really_ doubt that anything in mail system is capable of something
>> that elaborate.
> Again, I can not see it in my copy, I checked lkml archives too :
>
> http://lkml.org/lkml/2010/10/27/7
>
> Mail was fine, maybe your file system is corrupted ?
>
I have it in patch 4/4 too.
But in patch 1/4 could it be just a typo?

Christian Stroetmann

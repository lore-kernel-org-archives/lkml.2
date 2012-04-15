Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2DOKSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 06:18:36 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:42256 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2DOKSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 06:18:35 -0400
Message-ID: <4F8AA073.8090904@freemail.hu>
Date: Sun, 15 Apr 2012 12:18:27 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Arjan van de Ven <arjan@linux.intel.com>, discuss <discuss@lesswatts.org>,
        Powertop Mailing List <power@bughost.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [SOLVED] where can I find powertop sources?
References: <4F89304F.1070406@freemail.hu> <1334398320.1431.31.camel@localhost.localdomain>
In-Reply-To: <1334398320.1431.31.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 188.143.92.151
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
> Am Samstag, den 14.04.2012, 10:07 +0200 schrieb Németh Márton:
>> Hi,
> 
> hi,
> 
>> I'm having trouble to fetch powertop sources. I found the article
>> titled "Announcing the beta release of PowerTOP 2.0" from January 5 2011
>> at http://lwn.net/Articles/421733/ but it seems that the links are not
>> working anymore:
>>
>> $ git clone git://git.kernel.org/pub/scm/status/powertop/powertop.git
>> Cloning into powertop...
>> warning: You appear to have cloned an empty repository.
>> $ wget http://www.kernel.org/pub/linux/status/powertop/powertop-1.97.tar.bz2
>> --2012-04-14 10:04:55--  http://www.kernel.org/pub/linux/status/powertop/powertop-1.97.tar.bz2
>> Resolving www.kernel.org... 149.20.20.133, 149.20.4.69
>> Connecting to www.kernel.org|149.20.20.133|:80... connected.
>> HTTP request sent, awaiting response... 403 Forbidden
>> 2012-04-14 10:04:56 ERROR 403: Forbidden.
> 
> http://www.mail-archive.com/power@bughost.org/msg02155.html
> 
> The repository is at https://github.com/fenrus75/powertop or
> git://github.com/fenrus75/powertop.git
> 
> with kind regards
> thomas

Thanks, both of them works:

$ git clone https://github.com/fenrus75/powertop.git
Cloning into powertop...
remote: Counting objects: 3381, done.
remote: Compressing objects: 100% (866/866), done.
remote: Total 3381 (delta 2563), reused 3321 (delta 2503)
Receiving objects: 100% (3381/3381), 529.06 KiB | 366 KiB/s, done.
Resolving deltas: 100% (2563/2563), done.


$ git clone git://github.com/fenrus75/powertop.git
Cloning into powertop...
remote: Counting objects: 3381, done.
remote: Compressing objects: 100% (866/866), done.
remote: Total 3381 (delta 2563), reused 3321 (delta 2503)
Receiving objects: 100% (3381/3381), 529.06 KiB | 326 KiB/s, done.
Resolving deltas: 100% (2563/2563), done.

Regards,

	Márton Németh

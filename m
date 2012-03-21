Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030338Ab2CUBj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 21:39:28 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:43213 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab2CUBj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 21:39:26 -0400
Message-ID: <4F69317A.9040404@mprc.pku.edu.cn>
Date: Wed, 21 Mar 2012 09:40:10 +0800
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 27/38] Disintegrate asm/system.h for Unicore32 [ver #3]
References: <4F66F359.4060203@pku.edu.cn> <1331868043.1971.10.camel@epip-laptop> <20120315205514.28759.58969.stgit@warthog.procyon.org.uk> <20120315205931.28759.81875.stgit@warthog.procyon.org.uk> <17897.1331889018@redhat.com> <28091.1332238514@redhat.com>
In-Reply-To: <28091.1332238514@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 06:15 PM, David Howells wrote:
> Guan Xueao<gxt@pku.edu.cn>  wrote:
>
>>> Do the upstream binutils and gcc support unicore32 targets?
>>>
>>> David
>>>
>> Not yet. Sorry for the inconvenience.
> Do you have patches I could apply to my cross-compiler RPMs?  I'm using
> gcc-4.7 and binutils-2.22.52.0.1.  See:
>
> 	http://people.redhat.com/~dhowells/cross/
>
> David
>
For now, gcc porting version for unicore32 is 4.4.2, and binutils 
porting version for unicore32 is 2.19.1.
Anyway, thanks a lot.

Guan Xuetao

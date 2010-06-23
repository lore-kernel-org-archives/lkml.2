Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab0FWGAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 02:00:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50508 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab0FWGAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 02:00:05 -0400
Message-ID: <4C21A39C.6040406@ontolinux.com>
Date: Wed, 23 Jun 2010 08:03:08 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: ext Kees Cook <kees.cook@canonical.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux File System ML <linux-fsdevel@vger.kernel.org>,
       Linux Security Module ML 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] security: Yama LSM
References: <20100621213424.GG24749@outflux.net> <201006220028.o5M0Sbx7062650@www262.sakura.ne.jp> <20100622011452.GN24749@outflux.net> <4C20ABC0.5050908@nokia.com> <20100622160613.GC5876@outflux.net>
In-Reply-To: <20100622160613.GC5876@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18f0i/MQEO0ft3FsStG9W+vUN9Qzi2s8gU2dvg
 v6kQOGcD6K/hhrP2xlAoMJhyiSrCRRt8ECxtu0BMEwQVVu09ps
 KvdSDoHIDNlfFinPM+QFg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.06.2010 18:06, ext Kees Cook wrote:
> Hi Dmitry,
>
> On Tue, Jun 22, 2010 at 03:25:36PM +0300, Dmitry Kasatkin wrote:
>    
>> What is YAMA?
>>      
> "Yama" is just the name of the LSM.  It's inspired by:
> http://en.wikipedia.org/wiki/Yama
>    

Really?
>    
>> Where is the tree?
>>      
> At the moment:
> http://kernel.ubuntu.com/git?p=kees/linux-2.6.git;a=shortlog;h=refs/heads/yama
>
> -Kees
>    

"You've already had those suggestions some days ago. Use a security 
module, either by using something like SELinux (where you can do this 
just fine as far as I can see including exceptions by label for problem 
apps)", [Alan Cox, 2010-06-08], or integrate it into an already existing 
solution eg. grsecurity (www.grsecurity.net).

Christian Stroetmann

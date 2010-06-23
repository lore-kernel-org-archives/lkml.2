Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab0FWGkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 02:40:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58173 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab0FWGkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 02:40:12 -0400
Message-ID: <4C21AD07.5050201@ontolinux.com>
Date: Wed, 23 Jun 2010 08:43:19 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] security: Yama LSM
References: <20100621213424.GG24749@outflux.net> <201006220028.o5M0Sbx7062650@www262.sakura.ne.jp> <20100622011452.GN24749@outflux.net> <4C20ABC0.5050908@nokia.com> <20100622160613.GC5876@outflux.net> <4C21A39C.6040406@ontolinux.com> <20100623062242.GG5876@outflux.net>
In-Reply-To: <20100623062242.GG5876@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/o+Dcht+NZQp6DxFcpm1/cd1yPL8OcwGransL
 zyzjBokPkl5ALy22mSn4Seae3x/1kxt5d2R6PZXf018a+EkZK2
 h4G6owKrLmMSyP7fZ5wug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.06.2010 08:22, Kees Cook wrote:
> On Wed, Jun 23, 2010 at 08:03:08AM +0200, Christian Stroetmann wrote:
>    
>> "You've already had those suggestions some days ago. Use a security
>> module, either by using something like SELinux (where you can do
>> this just fine as far as I can see including exceptions by label for
>> problem apps)", [Alan Cox, 2010-06-08], or integrate it into an
>> already existing solution eg. grsecurity (www.grsecurity.net).
>>      
> You appear to be quoting[1], but you left off a bit.  To edit it a bit:
>
>    "Use a security module, either by using something like SELinux (...),
>    or write your own little security module that does it."
>
> I have done the latter.
>
> I don't need to integrate this into grsecurity because grsecurity already
> has these protections.  It is Openwall and grsecurity that I'm using as the
> starting point for this attempt at upstreaming the protections.
>    

So, this sounds as if you are porting functionalities from grsecurtiy 
into LSM. But [1].
> -Kees
>
> [1] http://lkml.org/lkml/2010/6/8/56
>
>    
[1] http://www.grsecurity.net/lsm.php

Chrisitan Stroetmann

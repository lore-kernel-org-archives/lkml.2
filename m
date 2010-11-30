Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab0K3WRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:17:36 -0500
Received: from zfrontend1.aha.ru ([195.2.83.147]:47394 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752261Ab0K3WRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:17:35 -0500
From: "werner" <w.landgraf@ru.ru>
Subject: Re: [PATCH] staging: easycap needs  smp_lock.h, fixes build
 error
To: greg@kroah.com, randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Tue, 30 Nov 2010 18:17:31 -0400
Message-ID: <web-413524031@zbackend1.aha.ru>
In-Reply-To: <20101130145740.GA11199@kroah.com>
References: <web-407197955@zbackend1.aha.ru>
 <20101122043520.GA10958@kroah.com>
 <20101121205626.4589e544.randy.dunlap@oracle.com>
 <20101121211311.05963007.randy.dunlap@oracle.com>
 <20101122194736.GA29830@kroah.com>
 <20101122121237.38cdd369.randy.dunlap@oracle.com>
 <web-413291852@zbackend1.aha.ru>
 <20101130145740.GA11199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK  For your information, the patch by r.dunlap works on 
2.6.37-rc4 too, the second compilation (including the 
patch) was successful.
wl

===========================
On Tue, 30 Nov 2010 06:57:40 -0800
  Greg KH <greg@kroah.com> wrote:
> On Tue, Nov 30, 2010 at 10:44:21AM -0400, werner wrote:
>> HELLO
>> 
>> I dont believe this ... my 2.6.37-rc4 compilation gone 
>>bad again,
>> because of the same error, and I have to recompile / 
>>re-package it,
>> what needs some hours again ..  :(  :(
>> 
>>  The correction below worked on 2.6.37-rc3 (i.e. insert 
>>#include
>> <linux/smp_lock.h>  into easycap_main.h)
>> 
>> 
>> WHY THIS WASN'T PATCHED SINCE LONG TIME ?   Is the 
>>situation of the
>> kernel developers similar bad like of the open office 
>>developers, so
>> that they should be exchanged ???
> 
> This is fixed in Linux-next and will be going to Linus 
>in a few days.
> 
> thanks,
> 
> greg k-h
> 
> 

"werner" <w.landgraf@ru.ru>
---
Professional hosting for everyone - http://www.host.ru

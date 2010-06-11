Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab0FKWiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:38:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33163 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab0FKWit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MZSc02b81Z+gwN4nEvMaJDSLatD7FnkAmFHenLDI4JcWNynYJpx9PAXYa57R16OrRQ
         eWAGGF1LSEI/JV0IhJ9QQuyk8hmx+9MkyxH+0z0cxgOXIxjCxG6C8YGeAlNwM9WESOHV
         2aMw4ItrNf3UOjToU3HHemOm+58iP5ARuPX68=
Message-ID: <4C12B789.1090206@gmail.com>
Date: Fri, 11 Jun 2010 15:24:09 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       zippel@linux-m68k.org, linux-fsdevel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 1/6]scripts:conf.c Fix warning: variable 'type' set but
 not used
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com> <1276288869-16815-2-git-send-email-justinmattock@gmail.com> <4C12B685.30101@suse.cz>
In-Reply-To: <4C12B685.30101@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 03:19 PM, Michal Marek wrote:
> On 11.6.2010 22:41, Justin P. Mattock wrote:
>> Not sure if this is correct or not, but with
>> make menuconfig
>>    HOSTCC  scripts/kconfig/conf.o
>> scripts/kconfig/conf.c: In function 'conf_sym':
>> scripts/kconfig/conf.c:159:6: warning: variable 'type' set but not used
>> scripts/kconfig/conf.c: In function 'conf_choice':
>> scripts/kconfig/conf.c:231:6: warning: variable 'type' set but not used
>>    HOSTLD  scripts/kconfig/mconf
>>
>> I get this using gcc 4.6.0 the below change fixes this form me.
>> please have a look and let me know.
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>
> Thanks, applied.
>
> Michal
>


o.k...

Justin P. Mattock

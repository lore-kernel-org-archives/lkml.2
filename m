Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab0IQROd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 13:14:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54404 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab0IQROc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 13:14:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rEHXZ6i9Jb1jGvk6iWcUiM4XI/Q3K8aD24rUZSU0Dqfrb1T+Y+9moDx6pnwZqgYAcS
         uu7JLF1YpdQDRpEnno1Qf7u2u1TDggdWZWF/94LWrZYcj7qXEY6dbZ7P4YGnmJPGTLuY
         Tjq0liE6IH4PNM6HyDOKhoiL6VAlEgrwmK7yk=
Message-ID: <4C93A227.7040807@gmail.com>
Date: Fri, 17 Sep 2010 10:15:19 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scripts/kconfig/gconf.glade Update broken web addresses.
References: <1284407756-4195-1-git-send-email-justinmattock@gmail.com> <4C9381C2.7050608@suse.cz>
In-Reply-To: <4C9381C2.7050608@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2010 07:57 AM, Michal Marek wrote:
> On 13.9.2010 21:55, Justin P. Mattock wrote:
>> As discussed, remove the DOCTYPE declaration since libglade validates
>> the file against itself..
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>> Signed-off-by: Michal Marek<mmarek@suse.cz>
>> ---
>>   scripts/kconfig/gconf.glade |    1 -
>>   1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/scripts/kconfig/gconf.glade b/scripts/kconfig/gconf.glade
>> index d52b0a7..aa483cb 100644
>> --- a/scripts/kconfig/gconf.glade
>> +++ b/scripts/kconfig/gconf.glade
>> @@ -1,5 +1,4 @@
>>   <?xml version="1.0" standalone="no"?>  <!--*- mode: xml -*-->
>> -<!DOCTYPE glade-interface SYSTEM "http://glade.gnome.org/glade-2.0.dtd">
>
> Applied.
>
> Michal
>


alright!!

Justin P. Mattock

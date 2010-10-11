Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab0JKQ7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 12:59:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64049 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab0JKQ7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 12:59:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZU+fZB6hUnrUQHM3XM0oIpEXuASjzQfF/YBaxIqJRbyxI1mKcps7mfDdxmOEjt8Ug3
         +0rwKUXzlZSr5XFrQQBC7oRl2K4yN56qkcNlGdqce0HYuFSzSL+pS9lA0ERW2FwEcAu6
         yfLna1XtxfO8i7TNfMD9lfUxKD+hxi0ky/a9M=
Message-ID: <4CB34063.70803@gmail.com>
Date: Mon, 11 Oct 2010 18:50:43 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kieran Bingham <kieranbingham@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 11/16] pramfs: ACL management
References: <4CB1EAD8.2030206@gmail.com> <4CB30266.1010706@gmail.com>
In-Reply-To: <4CB30266.1010706@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/10/2010 14:26, Kieran Bingham ha scritto:
>  On 10/10/2010 17:33, Marco Stornelli wrote:
>> From: Marco Stornelli<marco.stornelli@gmail.com>
>>
>> ACL operations.
>>
>> Signed-off-by: Marco Stornelli<marco.stornelli@gmail.com>
>> ---
>> diff -Nurp linux-2.6.36-orig/fs/pramfs/acl.c linux-2.6.36/fs/pramfs/acl.c
>> --- linux-2.6.36-orig/fs/pramfs/acl.c    1970-01-01 01:00:00.000000000
>> +0100
>> +++ linux-2.6.36/fs/pramfs/acl.c    2010-09-14 18:49:52.000000000 +0200
>> @@ -0,0 +1,418 @@
>> +/*
>> + * FILE NAME fs/pramfs/acl.h
> Found another one :)
> FILE NAME != acl.h ...
> -- 
> KB
> 

Oops, damn copy&paste ;) I'll fix it asap.

Thanks.

Marco

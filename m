Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab0IKShj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 14:37:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43227 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab0IKShi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 14:37:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uL9/aGrR+FKFdFm8n3nlRfW+52xZsxSBYJFUfhi5Ugjij8I/21jqVXkqi7u4KX0397
         ZPUWNgDyxRLvMmFwqBQBgcEJhihGGU98mBa35QXNGdYiQ4cm+hPtF3rF9REs/1zK7bKD
         dYhYOdT67KP8mizcpmljhzAJU0BE+KaBhnF14=
Message-ID: <4C8BCC98.4070506@gmail.com>
Date: Sat, 11 Sep 2010 11:38:16 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: git crapps out with {kernel_version}/usr/include
References: <4C8BB4F3.3040907@gmail.com> <20100911110050.1c6f275c.rdunlap@xenotime.net>
In-Reply-To: <20100911110050.1c6f275c.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2010 11:00 AM, Randy Dunlap wrote:
> On Sat, 11 Sep 2010 09:57:23 -0700 Justin P. Mattock wrote:
>
>> finishing up with looking at broken web addresses Im noticing that
>> usr/include/* seems to not work with git i.e. theres a couple of broken
>> addresses in there after changing them, then using git commit -s -a
>> gives me the "nothing to commit message"..
>> why is this?
>
> usr/include/* is all generated files from elsewhere in the kernel tree,
> so you should just change the original files, not the generated ones.
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>

yeah.. that's what I just realized.. then in this case it's probably 
fixed then... as for the rest I went through most of all the 
directories(keep in mind only http, didn't check www nor any other 
protocol) only a few files in the source tree are left(MAINTAINERS, 
etc...) so now the kernel to the most part has working web addresses..
This is what happens when I challenge myself...

Justin P. Mattock

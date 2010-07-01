Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab0GAP46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:56:58 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57055 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245Ab0GAP4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:56:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OnGteQfHZK1VBjBUvY9BirkrLkB2fi84YK2JkewGyhELfhq2mtn2gSncjr1b9yHwrz
         m0TnUmc5HU+XLV5vFBw1Kf3SszqVHCT8zMAzLOIO+tZJcD4JqCDwVknuYCUOdfh4LXu3
         TTVf+AWDKyxPL6jGv7uMIs3vb/MJepONgcaZU=
Message-ID: <4C2CBAE0.1030701@gmail.com>
Date: Thu, 01 Jul 2010 08:57:20 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jkosina@suse.cz
Subject: Re: [PATCH]kernel.h Move warning message about using kernel headers
 for userspace to types.h
References: <1277935785-6023-1-git-send-email-justinmattock@gmail.com> <201007010958.46720.arnd@arndb.de> <4C2C9962.3080307@gmail.com> <201007011707.31783.arnd@arndb.de>
In-Reply-To: <201007011707.31783.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2010 08:07 AM, Arnd Bergmann wrote:
> On Thursday 01 July 2010, Justin P. Mattock wrote:
>>>>
>>>> +#ifndef __EXPORTED_HEADERS__
>>>> +#ifndef __KERNEL__
>>>> +#warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders"
>>
>> so this is legit with the length of the statement? or should this be
>> broken down into a small quick line directing to a file with the address
>> or something
>
> Yes, the length of the statement was never the problem, it only went wrong
> because the // in the url gets interpreted as the start of a one-line comment.
>
> 	Arnd
>

alright.. then I'll look at getting this resent today.

Justin P. Mattock

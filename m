Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab0GKUHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 16:07:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:60051 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab0GKUHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 16:07:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pfrRxMwa7S7VM7dM3iN98aFjlRDsNOS8P6utgbh1xJgcY5nkm4aAtIqPXcCTP353/u
         aCHMtLlxztBX5lW55NMHUGf7N8G3pEPqLtHnhDVeTWUjhqeGKz03n2U//tB1nsrZe9Iv
         r1VkDv4r13IOk1LuWtQwg3ZG2dIUxnaTZ1Puk=
Message-ID: <4C3A2468.6010508@gmail.com>
Date: Sun, 11 Jul 2010 13:07:04 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de
Subject: Re: [PATCH v3]kernel.h Move preprocessor #warning about using kernel
 headers in userpsace to types.h
References: <1278019707-30585-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1007112139140.4741@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1007112139140.4741@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2010 12:39 PM, Jiri Kosina wrote:
> On Thu, 1 Jul 2010, Justin P. Mattock wrote:
>
>> Move the preprocessor #warning message:
>> warning: #warning Attempt to use kernel headers from user space,
>> see http://kernelnewbies.org/KernelHeaders
>> from kernel.h to types.h.
>> And also fixe the #warning message due to the preprocessor not being
>> able to read the web address due to it thinking it was the start of a comment.
>> also remove the extra #ifndef _KERNEL_ since it's already there.
>
> I have applied the patch, thanks Justin for your persistence, and thanks
> for reviews while I have been offline, Arnd.
>


cool alright.. was wonder if this was correct or not, from this it seems 
it is..(if I see anything I'll send it out..)

Thanks as well for being patient with me..

Justin P. Mattock

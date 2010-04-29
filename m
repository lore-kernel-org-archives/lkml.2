Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab0D2DMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 23:12:14 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35436 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0D2DMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 23:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Bq33c6DIySANZOxki32Y3IJ3uSJtQyW/wRHBotI60s2SuFDYI8+yQ552wXeARSTi9R
         lMdpri8IqAdSoWNuOZmdfacRCNZMzntJPVBxINxzZHGrpZTcghQ53bY5WQs0bt93xX4a
         wAD44nCvRZhJWFyBCI3dgAWn2kT/MoTbMVZNY=
Message-ID: <4BD8F927.2070703@gmail.com>
Date: Wed, 28 Apr 2010 20:12:39 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Alex Elsayed <eternaleye@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Very bad regression from 2.6.33 as of 1600f9def
References: <loom.20100429T041908-663@post.gmane.org> <4BD8F457.10205@gmail.com> <loom.20100429T045742-593@post.gmane.org>
In-Reply-To: <loom.20100429T045742-593@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2010 08:05 PM, Alex Elsayed wrote:
> Justin P. Mattock<justinmattock<at>  gmail.com>  writes:
>>
>> what is the last good kernel?
>> can you bisect this?
>>
>> Justin P. Mattock
>>
>
> Last good kernel was 2.6.33 release, right after tagging.
> I'll try and bisect. Probably be a while before I have anything,
> since the CPU is rather slow. Hopefully last good will work in qemu.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

yep.. luckily 33 is not that far behind
so it shouldn't take too long.
As for the CPU patience my friend..

Justin P. Mattock

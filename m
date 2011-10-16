Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1JPXNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 19:13:16 -0400
Received: from oceanic.CalvaEDI.COM ([89.202.194.168]:32928 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab1JPXNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 19:13:15 -0400
Message-ID: <4E9B6511.4060107@calvaedi.com>
Date: Mon, 17 Oct 2011 01:13:21 +0200
From: John Hughes <john@calvaedi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: John Hughes <john@Calva.COM>, linux-kernel@vger.kernel.org,
        Mattia Dongili <malattia@linux.it>, Stelian Pop <stelian@popies.net>
Subject: Re: sony-laptop driver: Volume keys on Sony Vaio TX3 don't work
References: <4E9ABBF6.3000504@calvaedi.com> <4E9ADBD3.4070404@calvaedi.com>            <4E9B182A.3020101@calvaedi.com> <74494.1318789218@turing-police.cc.vt.edu>
In-Reply-To: <74494.1318789218@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2011 08:20 PM, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 16 Oct 2011 19:45:14 +0200, John Hughes said:
>    
>
>> Here's a patch that makes the volume keys work for me.  Tested on
>> current git
>>      
> Do we know if this is applicable to all Sony laptops, or only a few 
> busticated
> models?
>
>
>    
The current code is simply wrong.  It might work by accident on some 
models, but.,..


(Why wrong? it says event (0x01,0x05) is PROG1, but event (0x01, 0x05) 
is Volume up,  Make up your mind please.  PS it's volume DOWN not up).

Wouldn't it be easier just to leave the decision for user mode?  Make 
the different events generate different "scancodes" and let udev sort 
them out?


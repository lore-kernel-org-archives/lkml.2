Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab2DEHH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 03:07:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60892 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab2DEHHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 03:07:46 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1204042308470.7534@chino.kir.corp.google.com>
References: <CAOVJa8EVHhfFfHHNAyAeT0ZYj3vZFW3Uu4K2PzBEGGOz92fhiw@mail.gmail.com>
	<alpine.DEB.2.00.1204042308470.7534@chino.kir.corp.google.com>
Date: Thu, 5 Apr 2012 15:07:46 +0800
Message-ID: <CAOVJa8GEVr69+FStuiyu3vyejD+4PZtyKm=vO3n9=LkqgS==1Q@mail.gmail.com>
Subject: Re: some questions about __get_vm_area_node
From: vichy <vichy.kuo@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>,
        Kernel Newbies <kernelnewbies@nl.linux.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi david:

2012/4/5 David Rientjes <rientjes@google.com>:
> On Thu, 5 Apr 2012, vichy wrote:
>
>> Hi all:
>> I have a question about __get_vm_area_node.
>> Q. Why we announce "static struct vmap_area *va;" instead of "struct
>> vmap_area *va;"
>> I cannot see is there any benefit to take this variable as static.
>>
>
> You're right, there's no need for it to be static.  However, you're
> looking at an old tree.
>
> This was fixed with 0006526d78e9 ("mm/vmalloc.c: remove static declaration
> of va from __get_vm_area_node") in 3.3.

Yes, I saw your check in message on Mon Dec 19 17:12:04 2011 -0800.
BTW, why we declare it as static previously?
for saving stack usage?
Thanks for your help,

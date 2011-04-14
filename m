Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab1DNKdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:33:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45095 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab1DNKdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:33:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=xJ5ikwdLph3vwtNmAL9CLhbv/Ebcsevmoki6eLwTHo0ChefxwqQEiGDbNqqOvCtUNJ
         JHPGVVCfNbqIboV9Ez1DN6xDuaEVa7Fxn0YZGvynO+Ls4q5avcGkXTu18nQNOTGf31KT
         OMaHHBgDQCf70lelzwQvgIsW+4YKd4vJ/tg9o=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Sergei Shtylyov" <sshtylyov@mvista.com>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Alan Stern" <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: storage_common: use kstrto*()
References: <c7bc1074f7cd049786ac2d50fe71b5e3ca0beba2.1302732994.git.mina86@mina86.com> <4DA6CC9B.1040702@ru.mvista.com>
Date: Thu, 14 Apr 2011 12:32:59 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vtxbk91x3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <4DA6CC9B.1040702@ru.mvista.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 14-04-2011 2:37, Michal Nazarewicz wrote:
>> This commit replaces the usage of strict_strtoul() (which
>> became deprecated after commit 33ee3b2e) with kstrtouint().

On Thu, 14 Apr 2011 12:29:47 +0200, Sergei Shtylyov <sshtylyov@mvista.com>  
wrote:
>     Please also specify that commit's summary -- for the human readers.

Guess it's too late (Greg already pulled the patch).  Good point though,
will keep in mind in the future.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--

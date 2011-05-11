Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab1EKPsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:48:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43581 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab1EKPsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:48:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:mime-version
         :content-transfer-encoding:from:date:message-id:in-reply-to
         :user-agent;
        b=OujIJt6ttHJHambb2tg/e0nZhYEaGxhpFomZfIk6xr2NKS5LPN8Pa4uFghtHh5wMVZ
         1XDIIXyBwnmdQ1hn2+Is3APM8dEr0a1dTsKuHDmuNjryQhv+q4BMRs6+j8FpPpXsTwkS
         23ch/CqfLMeEz8ikr2Rg34nAvWhF2LwK/+QkE=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Roger Quadros" <roger.quadros@nokia.com>
Cc: gregkh@suse.de, stern@rowland.harvard.edu, sshtylyov@mvista.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/3] usb: gadget: storage: Add fsg_get_toc helper
References: <1302015569-9668-1-git-send-email-roger.quadros@nokia.com>
 <1302015569-9668-2-git-send-email-roger.quadros@nokia.com>
 <op.vtg1yhef3l0zgt@mnazarewicz-glaptop> <4DCA3F90.1080208@nokia.com>
 <op.vvbgh8ge3l0zgt@mnazarewicz-glaptop> <4DCA81B5.4040208@nokia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Date: Wed, 11 May 2011 14:59:53 +0200
Message-ID: <op.vvbid32d3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <4DCA81B5.4040208@nokia.com>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 05/11/2011 03:19 PM, ext Michal Nazarewicz wrote:
>> Before we were just ignoring the type of ToC requested, right?
>> So can we fail back to the ToC we served then when we hit
>> an unsupported TOC? Or does it make no sense at all? I'm not
>> saying it does. It probably doesn't. ;)

On Wed, 11 May 2011 14:31:49 +0200, Roger Quadros wrote:
> Before we were returning -EINVAL for unsupported request. We do the same  
> now.

Cool than, disregard my comment. ;)

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--

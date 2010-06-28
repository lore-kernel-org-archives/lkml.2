Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab0F1TDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:03:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45094 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab0F1TDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:03:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PJ5+dwxCbK5VmqHXqoMvjZ8GgSRsu01QxINv8i72Zu73yMxyB1x/PE9kA/3JVtp6Qv
         0uSydV03qdk7H4MpL/dF/LnzS/rs433dRjOFRzC01in9DACSUgm27jD4xq3FVmxvrrc4
         CgjumU2/Bs0VGFDkV0rt3XaK7BK0pL+BYT6wc=
Message-ID: <4C28F20C.20608@gmail.com>
Date: Mon, 28 Jun 2010 12:03:40 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, lenb@kernel.org,
       linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 3/5]acpi:glue.c Fix warning: variable 'ret' set but not
 used
References: <4C28E14D.5050701@gmail.com> <1277621246-10960-4-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com> <7214.1277729293@redhat.com> <8066.1277750854@redhat.com>
In-Reply-To: <8066.1277750854@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 11:47 AM, David Howells wrote:
> Justin P. Mattock<justinmattock@gmail.com>  wrote:
>
>> would just removing ret be good or will things go out of whack because of no
>> ret
>
> Don't you then get warnings for not capturing the result?
>
> David
>

not sure if it would give warnings for not capturing the result.
then doing this would be the way to go.

if (ret) {
printk(KERN_WARNING "dev%d: Failed to create physical_node sysfs link: 
%d\n");
}

but like you had said unnecessary braces, and only one statement
I'll look at this some more too see if I come up with anything.

Justin P. Mattock

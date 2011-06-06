Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab1FFNta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:49:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34002 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1FFNt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=bG4EFjVQchnZD8zuxBL+ypDMYft75yzCu1knozfqbjC64b8t96jvUDkhiLvw+H9CDp
         90JPwJctl9YyJGrfgeEN5Ozny6VsKxlg9FnuVHAO16MoBPxR1CnTRgXs+f+6m+Ehjr9L
         CucO6498OAzMsu0khsExz10E3aPCn6nucJnmk=
Message-ID: <4DECDAE5.3080006@suse.cz>
Date: Mon, 06 Jun 2011 15:49:25 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110531 Thunderbird/5.0b1
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: gregkh@suse.de, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: 8250, increase PASS_LIMIT
References: <1307307109-27776-1-git-send-email-jslaby@suse.cz> <20110606130945.7ad9edef@bob.linux.org.uk>
In-Reply-To: <20110606130945.7ad9edef@bob.linux.org.uk>
X-Enigmail-Version: 1.2a2pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2011 02:09 PM, Alan Cox wrote:
> On Sun,  5 Jun 2011 22:51:49 +0200
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
>> From: Jiri Slaby <jirislaby@gmail.com>
>>
>> With virtual machines like qemu, it's pretty common to see "too much
>> work for irq4" messages nowadays. This happens when a bunch of output
>> is printed on the emulated serial console. This is caused by too low
>> PASS_LIMIT. When ISR loops more than the limit, it spits the message.
>>
>> I've been using a kernel with doubled the limit and I couldn't see no
>> problems. Maybe it's time to get rid of the message now?
> 
> We need a limit to deal with hangs caused by misconfiguration /
> mis-detection on ISA ports in particular but we can certainly bump the
> limit to handle poor emulations.

Yeah, I meant it that way (get rid of the message by bumping the limit
-- this patch).

thanks,
-- 
js
suse labs

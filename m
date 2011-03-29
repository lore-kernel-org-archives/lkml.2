Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1C2MRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 08:17:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56639 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1C2MRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 08:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=lhQTcylOXjO/E/kgaeMjSgTusXW5bQekFcrGNsTGTCK1d0qvthnCnuJnaerqhZFrJ8
         ryEsi2OVe+h/9iazh+cExh37/J9rqOuPwmbtxyjZxhsoOGrQ9DEm4g4ha7oeuT2ZBId3
         92mm3RJQCFzrbUk1jLqJnIHsMMczZCMk20rU8=
Message-ID: <4D91CDE6.9060006@suse.cz>
Date: Tue, 29 Mar 2011 14:17:42 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Julian Anastasov <ja@ssi.bg>
CC: gregkh@suse.de, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/6] TTY: unify tty_init_dev fail path handling
References: <1300873717-27941-1-git-send-email-jslaby@suse.cz> <alpine.LFD.2.00.1103232250160.1634@ja.ssi.bg>
In-Reply-To: <alpine.LFD.2.00.1103232250160.1634@ja.ssi.bg>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 09:53 PM, Julian Anastasov wrote:
> 
>     Hello,
> 
> On Wed, 23 Mar 2011, Jiri Slaby wrote:
> 
>> Change it so that we call the deinit functions at one place at the end
>> of the function (by gotos). And while at it use some sane label names.
>>
>> This is a preparation for the deinitialization of tty in the next
>> patch.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
>> Cc: Julian Anastasov <ja@ssi.bg>
>> ---
>>
>> This is not tested yet, I'm building a kernel to test it a bit, but it
>> will take some time. If you could too to check if your problem
>> dissapears, it would be great.
> 
>     Thanks! Patches 1-5 work for me, I backported them
> to 2.6.33.8 for the test.

Thanks for testing. I see no regressions either.

Greg, will you take it?

regards,
-- 
js
suse labs

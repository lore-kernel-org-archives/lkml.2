Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab0FUPVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:21:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33466 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397Ab0FUPVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=lDF6qcD+8X8thFAzSaKieMMRtIc6W6yQoleWUH4IBR4HYYa/i5rw2cEwQxQZGQTPoP
         RCrmfP2TO0X+2GYhUQQqTauxTAPyAUm/H5fM/tVlqPmfn2Hk5dU4SSVzDSeonbkpoxqi
         C4SRxTmi4Rx0UllnC0bji64d0O3Bx8hyieAW4=
Message-ID: <4C1F8366.70306@gmail.com>
Date: Mon, 21 Jun 2010 17:21:10 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1rc2-2.2 Thunderbird/3.1
MIME-Version: 1.0
To: Nigel Cunningham <ncunningham@crca.org.au>
CC: Jiri Slaby <jslaby@suse.cz>, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 1/9] PM / Hibernate: swap,	switch to hibernate_io_handle
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz> <4C1205DC.1080200@crca.org.au>
In-Reply-To: <4C1205DC.1080200@crca.org.au>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 11:46 AM, Nigel Cunningham wrote:
> On 02/06/10 18:52, Jiri Slaby wrote:
>> I addressed the comments I got on the previous RFC. I left the handles
>> in place, the functions in hibernate_io_ops now works on them. Further
>> I got rid of the memory barriers and minimized global variables as much
>> as possible. Comments welcome.
> 
> I would like to hear the arguments for using these handles. I understand
> there may have been some previous discussion, but am unable to find it.
> 
> It seems far more sensible to me to not pass around a handle that
> virtually nothing actually uses, and instead store and utilise the state
> in the place where it is actually useful. If we had more than one struct
> hibernate_io_handle in use at a time, I could understand going this way.
> As it stands, however...

Hi, it I added that based on this: http://lkml.org/lkml/2010/3/24/458

-- 
js

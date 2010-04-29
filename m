Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab0D2Cvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 22:51:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49914 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab0D2Cvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 22:51:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=d07riA3jWFtbCk9c4ZFZEWEXnpSnNA7fIG+Uk0D5k3JVwK2AJCwjtGPsEjVLguYOnY
         U+uPXNpXVxJr54KSe3CyYi8myIOuh7OGhCOkpCji4Y8MURe5oIfSGr0JzDFd6I/WrIwz
         HpE8Z88bjzK6g0wcdoCdI/dgkPVyYE01bSTOE=
Message-ID: <4BD8F457.10205@gmail.com>
Date: Wed, 28 Apr 2010 19:52:07 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Alex Elsayed <eternaleye@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Very bad regression from 2.6.33 as of 1600f9def
References: <loom.20100429T041908-663@post.gmane.org>
In-Reply-To: <loom.20100429T041908-663@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm being bit by an extremely troublesome regression on HEAD (when the 
kernel
was built, at least) of Linus' tree. The symptoms are that the kernel boots,
blinks the cursor a few times, then reboots without showing any messages or
switching to the uvesafb mode specified on the commandline. Trying to 
boot the
kernel in qemu causes it to hang with a blank screen and a non-blinking 
cursor,
not even printing anything to a serial terminal. .config is below.

I'm on an MSI-1651-ID2 laptop, core2duo T5550, 4g ram, compiled with GCC 
4.4.3.

<----  clip  ----->

what is the last good kernel?
can you bisect this?

Justin P. Mattock

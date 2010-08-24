Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab0HXBhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 21:37:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44050 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab0HXBh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 21:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rk95pjcXM0t1IN0RnQiPdwBHbsOSf83j3w3NNJHeFhKSIeT/Gsn8IrbU+G1yDo++U1
         BANCXrTetJOkJDHJMpppONA77WeLlaRBazCL/tkIocKLTI8N/tH5xqLWJy6Ih+qs8n3i
         wQxYQklji5Ynqtsb/iqo19Ri1AR9787jxr2DE=
MIME-Version: 1.0
In-Reply-To: <1282281295.22370.400.camel@pasglop>
References: <1282107803.22370.173.camel@pasglop>
	<20100817.222818.193699062.davem@davemloft.net>
	<1282195403.22370.296.camel@pasglop>
	<20100818.222925.233689776.davem@davemloft.net>
	<1282281295.22370.400.camel@pasglop>
Date: Mon, 23 Aug 2010 20:37:23 -0500
X-Google-Sender-Auth: _a2S8ikWYjUWdP2ZKZjJQJN4Oh0
Message-ID: <AANLkTinsTMxmhScg2nfr=4hASqPbsqAOSgnG-V21N-P+@mail.gmail.com>
Subject: Re: [PATCH 1/2] powerpc: Make rwsem use "long" type
From: Timur Tabi <timur@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulus@au.ibm.com, linuxppc-dev@lists.ozlabs.org,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 12:14 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:

>  static inline int rwsem_is_locked(struct rw_semaphore *sem)
>  {
> -       return (sem->count != 0);
> +       return sem->count != 0;
>  }

Does this change make the code do anything different?

-- 
Timur Tabi
Linux kernel developer at Freescale

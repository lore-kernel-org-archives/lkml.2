Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841Ab0HEWvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:51:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48823 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591Ab0HEWvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:51:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EpfJMdxgTPhn1XbQVvipS85Fv8umZu8ZLufJPzTaatCagYEBr8C925SFcEmi5Kny5A
         cmjYfVqB20CwH61/M/N44lQmXyTZ9JIwRBYGwTB9sPm8wXPmkoFj7hk3FD27XpubZtyH
         cLtueyHp5zt7SHuDPyNqDeAiZV3VLHk+lk1xE=
Subject: Re: [PATCH 0/2 V3] Driver for Ricoh cardreader + few fixes
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281021809-20924-1-git-send-email-maximlevitsky@gmail.com>
References: <1281021809-20924-1-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 01:51:41 +0300
Message-ID: <1281048701.7148.13.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 18:23 +0300, Maxim Levitsky wrote: 
> Hi,
> 
> This is third revision of my patches that conatains one more fix, and few fixes
> for the driver.
> 
> Changes since V2:
> * Removed accidently added hunk from r852.c
> * Few cosmetic cleanups in the driver
> 
> 
> --- original description from v2 ---
> 
> Patches 1-2 have no reason to be held  back from beeing merged in 2.6.35
> In fact patch #2 should be added to -stable as well.
> 
> The actual driver (patch #3) is new driver, so it can't introduce regressions,
> thus I think it can go to 2.6.36 as well.
> 
> I already have report form one user that driver works.
Two users now...

> 
> Best regards,
> 	Maxim Levitsky
> 
> 

Andrew, this is the latest version of my patches.
Sorry again for the mess in V1 of patches I sent to you.


Best regards,
Maxim Levitsky


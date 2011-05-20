Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482Ab1ETGc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 02:32:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49333 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024Ab1ETGc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 02:32:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HVhn2/X/x67QeOgD16KwJ5FMPwcKI1cQHVtTu60540dAO0p3DmAjAc28yTxDyeehsC
         uyG59VnjsrADiKHOSeqbPhaqDKQgkTRv/qsfN3Yx7O/W6HsuUIX8Mm+Qw+kz68MF0yJc
         QxhaNvyKJ0Z3oItSCT04KouHbSjlAF1vLO0aI=
Subject: Re: [PATCH] UBIFS: don't fail on -EBADMSG when fixing free space
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: "Matthew L. Creech" <mlcreech@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTi=nmvdKNaNDCUUZQF3QX-jDydTSng@mail.gmail.com>
References: <1305196419.2713.84.camel@localhost>
	 <1305751647-3122-1-git-send-email-bengardiner@nanometrics.ca>
	 <BANLkTi=+V7PR_29pK3ooVggPmeicCG0eWg@mail.gmail.com>
	 <BANLkTi=nmvdKNaNDCUUZQF3QX-jDydTSng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 09:29:05 +0300
Message-ID: <1305872945.2630.119.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 09:28 -0400, Ben Gardiner wrote:
> So, at least on my hardware, the -74 error is expected when the 0xff
> pages are not dropped and so without the 'err != -EBADMSG' exception
> the free space fixup will cause the volume to fail mount for me:

Still confused. If you have empty and erased flash, then you program it
with all 0xFFs, you should be able to read it with no errors. If this is
not the case for you, you should fix the driver. UBIFS cannot help in
this case - we consider it as "broken flash driver" case.

I have not read your e-mail carefully because of limited amount of time,
but with quick reading I became confused - too much information :-)

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


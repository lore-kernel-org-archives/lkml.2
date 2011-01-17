Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab1AQCgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 21:36:12 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36596 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1AQCgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 21:36:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=b1nz76JGY4XtT3TK6GL489c5Bb0IxE/NLVDNM44gNlyI9MyKojsfRB8g4O8TZ/vvll
         7rrX7YNfjr3W8G7fkCFp+c0WODcugq2ebLNm3VUqgSMeNF6wQ4Q4j/6K5G6BoJtz20n9
         iUBIfgBq2FwZscTWMEhgZ3KKquLyjLYYlIe3I=
MIME-Version: 1.0
In-Reply-To: <20110116175109.GC13615@flint.arm.linux.org.uk>
References: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
	<1295183333-13802-6-git-send-email-akinobu.mita@gmail.com>
	<20110116175109.GC13615@flint.arm.linux.org.uk>
Date: Mon, 17 Jan 2011 11:36:09 +0900
Message-ID: <AANLkTim=n7iVn_b6CRaWzwLLocC-rbH58ueEFFs6vfv8@mail.gmail.com>
Subject: Re: [PATCH v4 05/24] arm: introduce little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Akinobu Mita <akinobu.mita@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/17 Russell King <rmk@arm.linux.org.uk>:
> On Sun, Jan 16, 2011 at 10:08:34PM +0900, Akinobu Mita wrote:
>> Introduce little-endian bit operations by renaming native ext2 bit
>> operations.  The ext2 bit operations are kept as wrapper macros using
>> little-endian bit operations to maintain bisectability until the
>> conversions are finished.
>
> This looks fine to me - is there any chance we can get this in to mainline
> so we can avoid conflicts between this and some patches I'm working on atm
> to fix the unsafe UP+SMP kernel combination with ARMs bitops ?

The le bitops is still unacceptable to mainline.
So please do the fixes without bothering about the conflict.

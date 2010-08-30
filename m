Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0H3NiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:38:01 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54507 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab0H3NiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=MvdntlKtbOaShDqpL1PdRA1AylUi0D6ZZvDYVPCkES1bsny0tVvV7E7AU5KHB91jqp
         RiwTImrE4mXlwmiLkjnlgKk66miSl/qDrR0S86G+OLJUcj2h7BTm5ekt0ka8jEPBJZFg
         e1223QYEqeCiqz0b02Yy31H6mvSUkBoDoeHZM=
MIME-Version: 1.0
In-Reply-To: <1283173086.12995.74.camel@brekeke>
References: <1283028125-6027-1-git-send-email-vapier@gentoo.org> <1283173086.12995.74.camel@brekeke>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 30 Aug 2010 09:31:48 -0400
X-Google-Sender-Auth: cQHM8bTU0XdDg9qCsvCqqYobBNc
Message-ID: <AANLkTi=e+_AhXjHp9EsZqNe2ZZYwW-uYu-wNQ5PkHf-i@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] mtd: Blackfin NFC: fix invalid free
 in remove()
To: dedekind1@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 08:58, Artem Bityutskiy wrote:
> On Sat, 2010-08-28 at 16:42 -0400, Mike Frysinger wrote:
>> Since info->mtd isn't dynamically allocated, we shouldn't attempt to
>> kfree() it.  Otherwise we get random fun corruption when unloading
>> the driver built as a module.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> ---
>> note: this should be merged for 2.6.36 and probably sent to stable trees
>
> You send the same patch 2 times once with this note and the other time
> without this note. Which one should be ignored?

they're the same thing.  i used a wrong option with git-send-email.
-mike

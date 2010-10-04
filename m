Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0JDMUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 08:20:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38319 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0JDMUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 08:20:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=c536ZBk+yxo/ffQRcGd3VCxZFifSdkdyXb+4c1dQmhHJl6dNQZEdv+DtSeYsgS6fLG
         n/1FN9y5rmVJOIWkMjFMLxf/0lMjxnqk3taYi6+jCxUHk+PZGuKAmi+y1kVd1svmIc2t
         uLhYLj1xU0mcpy/2LLvCMH0+uDWZYhoZvUFUQ=
Subject: Re: [PATCH UPDATED] jbd: Use printk_ratelimited() in
 journal_alloc_journal_head()
From: Namhyung Kim <namhyung@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101004113751.GA7982@quack.suse.cz>
References: <20101004094331.GC3589@quack.suse.cz>
	 <1286187133-12475-1-git-send-email-namhyung@gmail.com>
	 <20101004103145.GG3589@quack.suse.cz> <20101004113751.GA7982@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 21:20:04 +0900
Message-ID: <1286194804.1664.7.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-10-04 (월), 13:37 +0200, Jan Kara:
>   Grumble, you apparently didn't try to compile the thing... The patch
> was missing #include <linux/ratelimit.h>. I've fixed that up now. Please be
> more careful next time. Thanks.
> 
>  								Honza

Egads, I did compile-test but I forgot I did make allnoconfig before.
(And then I added ext3 support manually.) I'll double check a patch
before sending it in the future. Sorry for the inconvenience.

Thanks.

-- 
Regards,
Namhyung Kim



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1DSKE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 06:04:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50426 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1DSKEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 06:04:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eT71Tr7sy3auqZaSayWstSf2ZNyeT7WZB8keGGw/jqJR0qDx02rwzu6850QhiSB+nr
         3uGrfk3uYu8WOKnTSQftJsa/Z4XCGFlebI273tdLkxuofv/8SLITEr8ryCEa8CPJQmDK
         k6QgBxkqGHGvFYHULqYCcayVknzKWPGedJTDY=
Subject: Re: [PATCH] ubifs: Use empty_iops and empty_fops consistently
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: sedat.dilek@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <BANLkTinysw90tiWhFRmQH_0LWx7o+sD1-A@mail.gmail.com>
References: <1301874939-2630-1-git-send-email-sedat.dilek@gmail.com>
	 <1301900656.2760.6.camel@localhost>
	 <BANLkTi=WTWa4yj+ysta8jiHs9r4MX5Gf_g@mail.gmail.com>
	 <1301911604.2760.52.camel@localhost>
	 <BANLkTi=DHTjL7M9bzYY-t5MJS2s1WScBCQ@mail.gmail.com>
	 <BANLkTinysw90tiWhFRmQH_0LWx7o+sD1-A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 13:02:00 +0300
Message-ID: <1303207320.2779.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 11:50 +0200, Sedat Dilek wrote:
> can you take this patch into your UBIFS tree?
> Thanks in advance.

Sorry, forgot about this patch. Pushed to ubifs-2.6.git tree, but I
re-wrote the commit message because I found yours a bit confusing. Is
this OK?

http://git.infradead.org/ubifs-2.6.git/commit/8c355ad269c9da635fad8367e9a6d52bf3fe08c8

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


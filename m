Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab0GYFbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 01:31:16 -0400
Received: from smtp.nokia.com ([192.100.105.134]:29459 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab0GYFbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 01:31:14 -0400
Subject: Re: A few V7 fs improvements
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1279559802-19154-1-git-send-email-lkundrak@v3.sk>
References: <1279559802-19154-1-git-send-email-lkundrak@v3.sk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 25 Jul 2010 08:23:01 +0300
Message-ID: <1280035381.9990.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 25 Jul 2010 05:30:18.0192 (UTC) FILETIME=[77ACDD00:01CB2BBA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-19 at 19:16 +0200, Lubomir Rintel wrote:
> I'm resending these once again, since I suspect they may have gotten lost
> in a spam filter due to improper MTA configuration of mine.
> 
> They basically improve usability of PC v7 filesystems; such as those of
> PC/IX.

Hi, do you by any chance know where I can find some docs about what we
have in fs/sysv ? I saw issues there, but could not fix them because I
could not find any docs. There are several flavors of FSes which fs/sysv
supports, do you have anything which makes sense out of it and describes
what exactly we support, what are the differences, what is the FS
layout, etc.

Thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


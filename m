Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0DFQac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:30:32 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42632 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0DFQaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:30:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SycazUXNigwhb9evDg29XaK2uQzoHr8VgNAVYZu/xWRpgXCCFdGW1DM9EKPwE3/Rgp
         gsDLF8cuBMNDYbIevJJICwApVwZLdvZOhphyRi4XfTBJWDKX7D1ZbxIRc4O2C/9VmMI+
         jaOTIiVKwILrN7eDM9b37R+4waROz48uuuHrA=
MIME-Version: 1.0
In-Reply-To: <20100406154728.GF5288@laptop>
References: <1270482365.1814.138.camel@barrios-desktop>
	 <20100406154728.GF5288@laptop>
Date: Wed, 7 Apr 2010 01:30:24 +0900
Message-ID: <r2s28c262361004060930u95af7d62k5136aeb67c8d7019@mail.gmail.com>
Subject: Re: [PATCH 2/2] ntfs: use add_to_page_cache_lru
From: Minchan Kim <minchan.kim@gmail.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anton Altaparmakov <aia21@cantab.net>,
       Al Viro <viro@zeniv.linux.org.uk>, Jiri Kosina <jkosina@suse.cz>,
       Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-ntfs-dev@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Nick.

On Wed, Apr 7, 2010 at 12:47 AM, Nick Piggin <npiggin@suse.de> wrote:
> On Tue, Apr 06, 2010 at 12:46:05AM +0900, Minchan Kim wrote:
>>
>> While I discuss exportable add_to_page_cache_lru,
>> http://marc.info/?l=linux-mm&m=127047788612445&w=2
>> I found that
>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04472.html.
>>
>> Let's change to use it in ntfs.
>
> Thanks, I went through most filesystems and changed it in those too,
> including ntfs. Haven't had much feedback but I'll just send the
> patches to Andrew if they haven't been merged by next release.
>

Please, let me know it.
That's because actually I had a plan to change about some filesystem.
If you already did it, I don't need to do. :)

Thanks, Nick.



-- 
Kind regards,
Minchan Kim

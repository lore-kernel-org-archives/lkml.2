Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab3AHWAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:00:30 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:63798 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab3AHWA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:00:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAPkvG_fGpjcVqeYgZnzNM6dpicB5YaJP9TA9bz2nUDJrHtJkGw@mail.gmail.com>
References: <1357145621-3438-1-git-send-email-ngupta@vflare.org>
	<CAPkvG_fGpjcVqeYgZnzNM6dpicB5YaJP9TA9bz2nUDJrHtJkGw@mail.gmail.com>
Date: Tue, 8 Jan 2013 14:00:27 -0800
Message-ID: <CAPkvG_eY8Fucft_Up9HgxWbpr2YG8vCQ_Pwi3QMfxcgDkgQ+Tg@mail.gmail.com>
Subject: Re: [PATCH][RESEND] staging: zram: fix invalid memory references
 during disk write
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 12:25 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> On Wed, Jan 2, 2013 at 8:53 AM, Nitin Gupta <ngupta@vflare.org> wrote:
>> Fixes a bug introduced by commit c8f2f0db1 ("zram: Fix handling
>> of incompressible pages") which caused invalid memory references
>> during disk write. Invalid references could occur in two cases:
>>  - Incoming data expands on compression: In this case, reference was
>> made to kunmap()'ed bio page.
>>  - Partial (non PAGE_SIZE) write with incompressible data: In this
>> case, reference was made to a kfree()'ed buffer.
>>
>> Fixes bug 50081:
>> https://bugzilla.kernel.org/show_bug.cgi?id=50081
>>
>
> Greg: can you please add this to staging? It fixes an important issue
> and is tested by many users.
>


It's still not in staging. Any reason why you want to accept this patch?
Of course, this is the last reminder, won't bother you again.

Thanks,
Nitin

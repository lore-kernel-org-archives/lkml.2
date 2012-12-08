Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2LHAuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:50:40 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52112 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2LHAui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:50:38 -0500
MIME-Version: 1.0
In-Reply-To: <1354257909-2380-1-git-send-email-ngupta@vflare.org>
References: <1354257909-2380-1-git-send-email-ngupta@vflare.org>
Date: Fri, 7 Dec 2012 16:50:37 -0800
Message-ID: <CAPkvG_er9VYk6Qi5o_Gz33qYN1Mr9jPUXMBm461Q8dtQC4iEdw@mail.gmail.com>
Subject: Re: zram: fix invalid memory references during disk write
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 10:45 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> Fixes a bug introduced by commit c8f2f0db1 ("zram: Fix handling
> of incompressible pages") which caused invalid memory references
> during disk write. Invalid references could occur in two cases:
>  - Incoming data expands on compression: In this case, reference was
> made to kunmap()'ed bio page.
>  - Partial (non PAGE_SIZE) write with incompressible data: In this
> case, reference was made to a kfree()'ed buffer.
>
> Fixes bug 50081:
> https://bugzilla.kernel.org/show_bug.cgi?id=50081
>
> Upstream commit ID: c8f2f0d: zram: Fix handling of incompressible pages
> Apply to versions: 3.6.5, 3.6.6, 3.6.7, 3.6.8
>

Greg: can you please apply these patches to above stable versions
and also 3.6.9?

Thanks,
Nitin

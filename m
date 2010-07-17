Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086Ab0GQSKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 14:10:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439Ab0GQSKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 14:10:35 -0400
Message-ID: <4C41F1FD.50501@redhat.com>
Date: Sat, 17 Jul 2010 14:10:05 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Avi Kivity <avi@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] Allow sharing xvmalloc for zram and zcache
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org> <1279283870-18549-2-git-send-email-ngupta@vflare.org>
In-Reply-To: <1279283870-18549-2-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 08:37 AM, Nitin Gupta wrote:
> Both zram and zcache use xvmalloc allocator. If xvmalloc
> is compiled separately for both of them, we will get linker
> error if they are both selected as "built-in".
>
> So, we now compile xvmalloc separately and export its symbols
> which are then used by both of zram and zcache.
>
> Signed-off-by: Nitin Gupta<ngupta@vflare.org>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed

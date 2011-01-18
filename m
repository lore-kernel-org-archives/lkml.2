Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab1ARR5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 12:57:45 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37907 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1ARR5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:57:44 -0500
MIME-Version: 1.0
Message-ID: <9e7aa896-ed1f-4d50-8227-3a922be39949@default>
Date: Tue, 18 Jan 2011 09:53:58 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/8] zcache: page cache compression support
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org
 20110110131626.GA18407@shutemov.name>
In-Reply-To: <20110110131626.GA18407@shutemov.name>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6539.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Kirill A. Shutemov [mailto:kirill@shutemov.name]
> Sent: Monday, January 10, 2011 6:16 AM
> To: Nitin Gupta
> Cc: Pekka Enberg; Hugh Dickins; Andrew Morton; Greg KH; Dan
> Magenheimer; Rik van Riel; Avi Kivity; Christoph Hellwig; Minchan Kim;
> Konrad Rzeszutek Wilk; linux-mm; linux-kernel
> Subject: Re: [PATCH 0/8] zcache: page cache compression support
> 
> Hi,
> 
> What is status of the patchset?
> Do you have updated patchset with fixes?
> 
> --
>  Kirill A. Shutemov

I wanted to give Nitin a week to respond, but I guess he
continues to be offline.

I believe zcache is completely superceded by kztmem.
Kztmem, like zcache, is dependent on cleancache
getting merged.

Kztmem may supercede zram also although frontswap (which
kztmem uses for a more dynamic in-memory swap compression)
and zram have some functional differences that support
both being merged.

For latest kztmem patches and description, see:

https://lkml.org/lkml/2011/1/18/170 


Thanks,
Dan

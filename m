Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab2K0Rrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:47:52 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61588 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab2K0Rru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:47:50 -0500
MIME-Version: 1.0
In-Reply-To: <20121127170509.GA5100@linux.intel.com>
References: <CAMi7pMamJK079wQs+5Kaz=zdYGAPS+BFg2xCRKJMqPFMrQvQPQ@mail.gmail.com>
	<50B4AD8A.7020208@kernel.dk>
	<20121127170509.GA5100@linux.intel.com>
Date: Tue, 27 Nov 2012 09:47:48 -0800
X-Google-Sender-Auth: 4rWJ7yNZ4qvmYj-Xi2GPHUTNqdA
Message-ID: <CAMi7pMb7Ln02hLfa_i-7ucWZBDGzQLUOoQTeFp70=yGix_gojA@mail.gmail.com>
Subject: Re: Alignment Issue with Direct IO to NVMe Drive
From: Laine Walker-Avina <lwalkera@ieee.org>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, lwalkera@micron.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 9:05 AM, Matthew Wilcox <willy@linux.intel.com> wrote:
> Laine, when this occurs, what is the alignment of 'offset' in the sg
> entry you're looking at?  If userspace is passing in an unaligned address,
> I don't think there's anything we do to try to align it.

I thought this was the case as well, but it appears to be aligned
looking at the request in the user space program (fio using libaio in
this case) before the IO is submitted.

Laine

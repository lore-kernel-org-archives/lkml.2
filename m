Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab2B2M7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:59:18 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:56015 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab2B2M7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:59:17 -0500
Message-ID: <1330520244.4f4e20b4cfdc0@www.imp.polymtl.ca>
Date: Wed, 29 Feb 2012 07:57:24 -0500
From: Naveen Goswamy <naveen.goswamy@polymtl.ca>
To: "'Dave Jones'" <davej@redhat.com>
Cc: Jack Wang <jack_wang@usish.com>, "'Tejun Heo'" <tj@kernel.org>,
        "'Jun'ichi Nomura'" <j-nomura@ce.jp.nec.com>,
        "'Jens Axboe'" <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "'linux-scsi'" <linux-scsi@vger.kernel.org>,
        "'James Bottomley'" <James.Bottomley@HansenPartnership.com>,
        "'Stefan Richter'" <stefanr@s5r6.in-berlin.de>, sgruszka@redhat.com,
        "'Huajun Li'" <huajun.li.lee@gmail.com>
Subject: Re: [PATCH] Fix NULL pointer dereference in sd_revalidate_disk
References: <4F443E81.2060402@ce.jp.nec.com> <20120222010435.GI12236@google.com> <95E22EAF20104309BF3938E7820F36D6@usish.com.cn> <20120222053651.GA7891@redhat.com>
In-Reply-To: <20120222053651.GA7891@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.3
X-Originating-IP: 69.196.137.185
X-Poly-FromMTA: (imp-4-2.polymtl.ca [132.207.4.77]) at Wed, 29 Feb 2012 12:57:25 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tested this patch, and it fixes the problem where when I ejected the SD
card it would oops and crash and burn my kernel, as reported here :

https://lkml.org/lkml/2012/2/7/462

and here:

https://bugs.gentoo.org/show_bug.cgi?id=402433

I tested it with the 3.3-rc5 sources, found here:

http://www.kernel.org/pub/linux/kernel/v3.0/testing/



Thanks,

Tested-by:Naveen Goswamy





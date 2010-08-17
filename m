Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab0HQAWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 20:22:44 -0400
Received: from mail.perches.com ([173.55.12.10]:1099 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab0HQAWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 20:22:42 -0400
Subject: RE: [PATCH v2 1/3] libcxgbi: common library for cxgb3i and cxgb4i
From: Joe Perches <joe@perches.com>
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Rakesh Ranjan <rakesh@chelsio.com>,
        James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu
In-Reply-To: <8A71B368A89016469F72CD08050AD334084A2C95@maui.asicdesigners.com>
References: <201008130257.o7D2vLVx001282@localhost.localdomain>
	 <1281669700.15486.71.camel@Joe-Laptop>
	 <8A71B368A89016469F72CD08050AD33408403F41@maui.asicdesigners.com>
	 <1281977297.6518.68.camel@Joe-Laptop>
	 <8A71B368A89016469F72CD08050AD334084A2C95@maui.asicdesigners.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 17:22:37 -0700
Message-ID: <1282004557.24541.2.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 17:02 -0700, Karen Xie wrote:
> Thanks, Joe.
> 
> I will update the patch with your suggestion. BTW, I probably won't use
> pr_<level> just to avoid any confusion since they are already defined in
> kernel.h. I know I can undef them, but rather not to.

Hi Karen.

The point is to use pr_<level> precisely because it is
defined in kernel.h and they are standard kernel functions
commonly used in the rest of the kernel source.

There's no need to undef it any more than there is to
#undef printk or use a #define printf printk

cheers, Joe


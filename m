Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab1GSFSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 01:18:11 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:39678 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab1GSFSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 01:18:10 -0400
Subject: Re: [PATCH 1/2] scsi: target: fix typo Assoication -> Association
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>,
        target-devel <target-devel@vger.kernel.org>
In-Reply-To: <f051412fa68688dea6d9445d66fbd8085a07bdb7.1310977653.git.andriy.shevchenko@linux.intel.com>
References: <f051412fa68688dea6d9445d66fbd8085a07bdb7.1310977653.git.andriy.shevchenko@linux.intel.com>
Content-Type: text/plain
Date: Mon, 18 Jul 2011 22:08:58 -0700
Message-Id: <1311052138.16756.18.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 11:27 +0300, Andy Shevchenko wrote:
> Additionally this patch brings proper apply of the designator type.
> However, the original code luckily has no bug, because the association
> equals to 0.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
> Cc: James Bottomley <jbottomley@parallels.com>
> ---
>  drivers/target/target_core_cdb.c      |   10 +++++-----
>  drivers/target/target_core_configfs.c |    2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 

Committed as 300094f75ab1d into lio-core-2.6.git

Thanks Andy!

--nab


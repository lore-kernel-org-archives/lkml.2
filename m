Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab1GSFUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 01:20:33 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:39682 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab1GSFUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 01:20:32 -0400
Subject: Re: [PATCH 2/2] scsi: target: remove custom hex2bin()
	implementation
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>
In-Reply-To: <db7c7ad036769bcc0cd737e0b74136a05e57fc85.1310977653.git.andriy.shevchenko@linux.intel.com>
References: <f051412fa68688dea6d9445d66fbd8085a07bdb7.1310977653.git.andriy.shevchenko@linux.intel.com>
	 <db7c7ad036769bcc0cd737e0b74136a05e57fc85.1310977653.git.andriy.shevchenko@linux.intel.com>
Content-Type: text/plain
Date: Mon, 18 Jul 2011 22:11:21 -0700
Message-Id: <1311052281.16756.22.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 11:27 +0300, Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_cdb.c        |   16 ++++------------
>  drivers/target/target_core_fabric_lib.c |   17 +++++++----------
>  drivers/target/target_core_transport.c  |   28 ----------------------------
>  include/target/target_core_transport.h  |    1 -
>  4 files changed, 11 insertions(+), 51 deletions(-)
> 

Good catch to use proper include/linux/kernel.org:hex2bin() usage
instead of the custom code.

Committed as e270af8 with some minor changes to drop DEV_T10_WWN() macro
usage in favor of direct dereference following v4.1 style.

Thanks!

--nab



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab2FNBFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 21:05:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46155 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754134Ab2FNBFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 21:05:54 -0400
Message-ID: <1339635953.28729.8.camel@joe2Laptop>
Subject: Re: [PATCH] writeback: Maintainer Record
From: Joe Perches <joe@perches.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Date: Wed, 13 Jun 2012 18:05:53 -0700
In-Reply-To: <1339633873-12729-1-git-send-email-liwp.linux@gmail.com>
References: <1339633873-12729-1-git-send-email-liwp.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 08:31 +0800, Wanpeng Li wrote:
>  MAINTAINERS |   10 ++++++++++
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> +WRITEBACK
> +M:  Fengguang Wu <fengguang.wu@intel.com>

Generally the actual maintainer submits a patch
to this file.

Please use a single tab after each :

> +T:  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git tags/writeback
> +S:  Maintained
> +F:  include/linux/backing-dev.h
> +F:  mm/backing-dev.c
> +F:  include/linux/writeback.h
> +F:  fs/fs-writeback.c
> +F:  mm/page-writeback.c
> +




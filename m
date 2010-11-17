Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934656Ab0KQLxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 06:53:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:22594 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934550Ab0KQLxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 06:53:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,210,1288594800"; 
   d="scan'208";a="858501258"
Date: Wed, 17 Nov 2010 11:33:14 +0000
From: Alan Cox <alan@linux.intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Mike Frysinger <vapier@gentoo.org>, Feng Tang <feng.tang@intel.com>,
        Tobias Klauser <tklauser@distanz.ch>, yong.y.wang@intel.com,
        qi.wang@intel.com, kok.howg.ewe@intel.com,
        andrew.chih.howe.khor@intel.com
Subject: Re: [PATCH v5] EG20T: Update PCH_UART driver to 2.6.36
Message-ID: <20101117113314.5f2db145@linux.intel.com>
In-Reply-To: <4CE3281A.4050709@dsn.okisemi.com>
References: <4CE3281A.4050709@dsn.okisemi.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 09:55:54 +0900
Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com> wrote:

> Hi Alan,
> 
> I have modified for your indications.
>  - Delete unnecessary loop at tty_intert_flip_string processing.
>  - Replace pr_info to pr_debug in case tty_port_tty_get fails.
> 
> Please check below.

Acked-by: Alan Cox <alan@linux.intel.com>

There are other minor cleanups that could be done but nothing I see now
which is a barrier to merging it.

Alan

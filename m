Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab2LTTJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:09:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab2LTTJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:09:42 -0500
Date: Thu, 20 Dec 2012 14:09:23 -0500
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH v3 0/2] pstore,efi_pstore: Avoid deadlock in non-blocking
 paths
Message-ID: <20121220190923.GP88797@redhat.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A2A03B@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A2A03B@USINDEM103.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 03:11:14PM +0000, Seiji Aguchi wrote:
> Changelog 
> v2 -> v3
>  - Merge modifications of pstore part in 2/2 to 1/2.
>  - Rename pstore_is_non_blocking_path() to pstore_cannot_block_path().
> 
> v1 -> v2
>  - Erase a logic checking the number of online cpus.
>  - Create a patchset to fix deadlocking issue in both pstore filesystem and
>    efi_pstore driver.
>    - Introduce a function, is_non_blocking_path(), to check if pstore 
>      is in panic and emergency-restart paths (PATCH 1/2)
>    - Avoid efi_pstore_driver is blocked in non-blocking paths
>      such as nmi, panic and emergency-restart paths (PATCH 2/2)
> 
> [Issue]
> 
> There are some paths in kernel which shouldn't be blocked, 
> like NMI, panic case after stopping cpus, emergency-restart.

I am ok with it.

Acked-by: Don Zickus <dzickus@redhat.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab2BXAD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 19:03:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54224 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab2BXAD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 19:03:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.211.102 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Thu, 23 Feb 2012 16:03:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Spencer Krum <nibz@cat.pdx.edu>
Cc: nab@linux-iscsi.org, rdunlap@xenotime.net, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        MostAwesomeDude@gmail.com, Spencer O Krum <krum.spencer@gmail.com>
Subject: Re: [PATCH] Changed alocate to allocate in
 Documentation/target/tcm_mod_builder.py
Message-ID: <20120224000317.GA1055@kroah.com>
References: <1330041039-26284-1-git-send-email-nibz@cat.pdx.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330041039-26284-1-git-send-email-nibz@cat.pdx.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 03:50:39PM -0800, Spencer Krum wrote:
> From: Spencer O Krum <krum.spencer@gmail.com>
> 
> Signed-off-by: Spencer Krum <nibz@cat.pdx.edu>
> ---
>  Documentation/target/tcm_mod_builder.py |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>

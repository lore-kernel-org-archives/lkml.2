Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab1EJQZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 12:25:39 -0400
Received: from kroah.org ([198.145.64.141]:47555 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932828Ab1EJQZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 12:25:38 -0400
Date: Tue, 10 May 2011 09:11:37 -0700
From: Greg KH <greg@kroah.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mikew@google.com" <mikew@google.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH] pstore: EFI Support
Message-ID: <20110510161137.GA14522@kroah.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C16FB4712@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C16FB4712@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 11:00:44AM -0400, Seiji Aguchi wrote:
> Description of boot paremeters is following.
> 
>  - efi_pstore_enable
>    enable EFI support of pstore.
> 
>  - efi_pstore_len
>    Sets the buffer size of EFI variable space used by pstore.

Please don't add new boot parameters if at all possible.  Distros will
not know to enable them, and users don't know how to either.

Use sane defaults, and provide ways to override them if needed, but
don't rely on them for new functionality if at all possible.

Why would this option ever _not_ be something that should be enabled?

thanks,

greg k-h

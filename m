Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab2LUXsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 18:48:25 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:35079 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2LUXsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 18:48:21 -0500
Date: Fri, 21 Dec 2012 15:37:07 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "dzickus@redhat.com" <dzickus@redhat.com>
Subject: Re: [PATCH v3 0/2] pstore,efi_pstore: Avoid deadlock in non-blocking
 paths
Message-ID: <20121221233706.GA29709@lizard.sbx05280.losalca.wayport.net>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A2A03B@USINDEM103.corp.hds.com>
 <20121220190923.GP88797@redhat.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D414A2B22C@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A2B22C@USINDEM103.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 11:27:00PM +0000, Seiji Aguchi wrote:
> Tony,
> 
> Could you please apply this patchset to your tree?

Actually, I'd prefer to take both patches via pstore tree. The EFI part is
isolated and small, so even if it conflicts, it would be easy to resolve,
unlike to pstore core part.

So, would be great if Tony could give an Ack for EFI part and we'd merge
this via pstore tree.

Thanks,
Anton

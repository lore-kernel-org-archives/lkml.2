Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab1ETU77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 16:59:59 -0400
Received: from outmail010.snc4.facebook.com ([66.220.144.142]:64947 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754116Ab1ETU7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 16:59:55 -0400
Date: Fri, 20 May 2011 13:59:51 -0700
From: Arun Sharma <asharma@fb.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Arun Sharma <asharma@fb.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] kbuild: Append RPM release to $KERNELRELEASE
Message-ID: <20110520205951.GA20746@dev1756.snc6.facebook.com>
References: <1305653779-3445-1-git-send-email-asharma@fb.com>
 <1305653779-3445-5-git-send-email-asharma@fb.com>
 <4DD2D703.4030908@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD2D703.4030908@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 10:13:55PM +0200, Michal Marek wrote:
> 
> Please stop decorating the kernel release string for the sake of make
> rpm, thanks. If you really want the kernel release string match rpm's
> %{version}-%{release}, how about this: Let the user set
> CONFIG_LOCALVERSION=-<number> and check in make rpm if $KERNELRELEASE
> ends with -<number>. If so, use <number> in the Release: field and the
> rest in Version:, otherwise use the same scheme as before. That way, you
> won't force a new kernel release numbering scheme on anyone.

Turns out that even this patch isn't sufficient for what we were trying to
do. Let's drop this patch for now. The other patches are independent
and should still apply.

 -Arun


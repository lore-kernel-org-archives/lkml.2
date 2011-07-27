Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1G0NBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 09:01:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25601 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab1G0NBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 09:01:52 -0400
Date: Wed, 27 Jul 2011 08:59:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andy Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jeremy@goop.org, keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/5] Collected vdso/vsyscall fixes for 3.1
Message-ID: <20110727125947.GC6713@dumpdata.com>
References: <cover.1311736366.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1311736366.git.luto@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4E300BD0.003C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 11:20:34PM -0400, Andy Lutomirski wrote:
> This fixes various problems that cropped up with the vdso patches.
> 
>  - Patch 1 fixes an information leak to userspace.
>  - Patches 2 and 3 fix the kernel build on gold.
>  - Patches 4 and 5 fix Xen (I hope).
> 
> Konrad, could you could test these on Xen and run 'test_vsyscall test' [1]?
> I don't have a usable Xen setup.

Sure.

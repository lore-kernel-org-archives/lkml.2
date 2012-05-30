Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab2E3U3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:29:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39411 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab2E3U3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:29:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120529144743.GG3558@phenom.dumpdata.com>
References: <CAJ75kXbC3gqQAaghKo2i1L650dw9-vrFuEwoy4defagoyR8p4Q@mail.gmail.com>
 <20120521181558.GA7829@phenom.dumpdata.com> <alpine.LSU.2.00.1205261113470.2033@eggly.anvils>
 <20120529144743.GG3558@phenom.dumpdata.com>
From: William Dauchy <wdauchy@gmail.com>
Date: Wed, 30 May 2012 22:29:16 +0200
Message-ID: <CAJ75kXZSqyyk0j2sNS1gq8fV_Z+Kj12mxKmpOAjKmwhDxs_9vQ@mail.gmail.com>
Subject: Re: [Xen-devel] swap: don't do discard if no discard option added
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, shli@fusionio.com, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        xen-devel@lists.xensource.com, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Konrad,

On Tue, May 29, 2012 at 4:47 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> I think I know and just narrowed down the issue this Friday.
> William, could you please apply the patch outlined in
> https://bugzilla.redhat.com/show_bug.cgi?id=824641
> to your dom0 and see if that (so do not have 052b198 in your branch)

I applied the patch on dom0 and removed 052b198 from my virtual
machine and it worked.

Regards,
-- 
William

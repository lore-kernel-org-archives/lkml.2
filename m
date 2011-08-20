Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab1HTALe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 20:11:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756680Ab1HTAL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 20:11:28 -0400
Date: Fri, 19 Aug 2011 17:10:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: "Fabio M . Di Nitto" <fabbione@fabbione.net>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] kernel/printk: do not turn off bootconsole in
 printk_late_init if keep_bootcon
Message-Id: <20110819171024.7805dec6.akpm@linux-foundation.org>
In-Reply-To: <1312934553-17085-1-git-send-email-nacc@us.ibm.com>
References: <1312934553-17085-1-git-send-email-nacc@us.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Aug 2011 17:02:33 -0700
Nishanth Aravamudan <nacc@us.ibm.com> wrote:

> It seems that commit 7bf693951a8e5f7e600a45b74d91d962a453146e doesn't
> always achieve what it aims, as printk_late_init() runs it
> unconditionally turns off all boot consoles. With this patch, I am able
> to see more messages on the boot console in KVM guests than I can
> without, when keep_bootcon is specified.
> 
> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Greg KH <gregkh@suse.de>

The patch is applicable to 2.6.39.x and to 3.0.x but I'm unable to work
out if the end-user impact is sufficiently serious to warrant
backporting the fix into those kernels.

Please let us know you opinion on this.

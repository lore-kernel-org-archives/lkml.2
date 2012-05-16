Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab2EPRB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:01:28 -0400
Received: from mail.vyatta.com ([76.74.103.46]:34919 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab2EPRB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:01:27 -0400
Date: Wed, 16 May 2012 10:01:21 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Cc: linux-kernel@vger.kernel.org, acking@vmware.com, dtor@vmware.com,
        gregkh@linuxfoundation.org, virtualization@lists.linux-foundation.org,
        dsouders@vmware.com, akpm@linux-foundation.org, cschamp@vmware.com
Subject: Re: [vmw_vmci RFC 01/11] Apply VMCI context code
Message-ID: <20120516100121.3be6d0ca@nehalam.linuxnetplumber.net>
In-Reply-To: <1337094428-20453-2-git-send-email-astiegmann@vmware.com>
References: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
	<1337094428-20453-2-git-send-email-astiegmann@vmware.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012 08:06:58 -0700
"Andrew Stiegmann (stieg)" <astiegmann@vmware.com> wrote:

> Context code maintains state for vmci and allows the driver
> to communicate with multiple VMs.
> 
> Signed-off-by: Andrew Stiegmann (stieg) <astiegmann@vmware.com>

Running checkpatch reveals the usual noise, and the following that
should be addressed.

ERROR: do not use C99 // comments
#272: FILE: drivers/misc/vmw_vmci/vmci_context.c:183:
+static bool ctx_exists_locked(uint32_t cid)	// IN

ERROR: "foo * bar" should be "foo *bar"
#304: FILE: drivers/misc/vmw_vmci/vmci_context.c:215:
+		      uid_t * user, struct vmci_ctx **outContext)

I don't mind the C99 style comments, but the // IN convention
is pretty useless and should be removed.

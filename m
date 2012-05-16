Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233Ab2EPSeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:34:37 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:39398 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754131Ab2EPSeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:34:36 -0400
Date: Wed, 16 May 2012 11:34:35 -0700 (PDT)
From: Andrew Stiegmann <astiegmann@vmware.com>
To: Stephen Hemminger <shemminger@vyatta.com>, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, acking@vmware.com, dtor@vmware.com,
        virtualization@lists.linux-foundation.org, dsouders@vmware.com,
        akpm@linux-foundation.org, cschamp@vmware.com
Message-ID: <338409537.3067117.1337193275440.JavaMail.root@zimbra-prod-mbox-4.vmware.com>
In-Reply-To: <20120516100121.3be6d0ca@nehalam.linuxnetplumber.net>
Subject: Re: [vmw_vmci RFC 01/11] Apply VMCI context code
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.233.112.2]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - GC17 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both of your comments have been added to my "to do" list before the next time I publish.  Thanks for the feedback.

----- Original Message -----
> From: "Stephen Hemminger" <shemminger@vyatta.com>
> To: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
> Cc: linux-kernel@vger.kernel.org, acking@vmware.com, dtor@vmware.com, gregkh@linuxfoundation.org,
> virtualization@lists.linux-foundation.org, dsouders@vmware.com, akpm@linux-foundation.org, cschamp@vmware.com
> Sent: Wednesday, May 16, 2012 10:01:21 AM
> Subject: Re: [vmw_vmci RFC 01/11] Apply VMCI context code
> 
> On Tue, 15 May 2012 08:06:58 -0700
> "Andrew Stiegmann (stieg)" <astiegmann@vmware.com> wrote:
> 
> > Context code maintains state for vmci and allows the driver
> > to communicate with multiple VMs.
> > 
> > Signed-off-by: Andrew Stiegmann (stieg) <astiegmann@vmware.com>
> 
> Running checkpatch reveals the usual noise, and the following that
> should be addressed.
> 
> ERROR: do not use C99 // comments
> #272: FILE: drivers/misc/vmw_vmci/vmci_context.c:183:
> +static bool ctx_exists_locked(uint32_t cid)	// IN
> 
> ERROR: "foo * bar" should be "foo *bar"
> #304: FILE: drivers/misc/vmw_vmci/vmci_context.c:215:
> +		      uid_t * user, struct vmci_ctx **outContext)
> 
> I don't mind the C99 style comments, but the // IN convention
> is pretty useless and should be removed.
> 

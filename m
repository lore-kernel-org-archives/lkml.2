Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab2G0ABn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 20:01:43 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:60555 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753051Ab2G0ABm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 20:01:42 -0400
Date: Thu, 26 Jul 2012 17:01:41 -0700 (PDT)
From: Andrew Stiegmann <astiegmann@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com, vm-crosstalk@vmware.com, cschamp@vmware.com
Message-ID: <1388691188.5122729.1343347301577.JavaMail.root@vmware.com>
In-Reply-To: <20120726234954.GC3849@kroah.com>
Subject: Re: [vmw_vmci 07/11] Apply VMCI hash table
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC20 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Must have missed it.  Will look into it.

----- Original Message -----
> From: "Greg KH" <gregkh@linuxfoundation.org>
> To: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
> Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
> vm-crosstalk@vmware.com, cschamp@vmware.com
> Sent: Thursday, July 26, 2012 4:49:54 PM
> Subject: Re: [vmw_vmci 07/11] Apply VMCI hash table
> 
> On Thu, Jul 26, 2012 at 04:39:36PM -0700, Andrew Stiegmann (stieg)
> wrote:
> > Implements a hash table for VMCI's use.
> 
> What's wrong with the in-kernel hash table(s)?
> 
> 

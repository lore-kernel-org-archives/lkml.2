Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab2JYV24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 17:28:56 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:34767 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906Ab2JYV2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 17:28:54 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2012 17:28:54 EDT
Date: Thu, 25 Oct 2012 14:18:52 -0700 (PDT)
From: Bhavesh Davda <bhavesh@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: pv-drivers@vmware.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, vm-crosstalk@vmware.com,
        George Zhang <georgezhang@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>
Message-ID: <1451569351.17004753.1351199932851.JavaMail.root@vmware.com>
In-Reply-To: <20121025210448.GB12352@kroah.com>
Subject: Re: [Pv-drivers] [PATCH 04/10] VMCI: device driver implementaton.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2674 (ZimbraWebClient - GC22 (Mac)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For many many years, you shipped closed source Linux kernel drivers
> for
> your products.  Only recently has this changed.

and

> > all our Linux drivers, even if not all are upstream [yet], are GPL.
> 
> That's nice to hear, although without proof of that, we have to take
> your word :)

The following VMware drivers are in mainline Linux now (thanks to you and other members of the kernel community for that!)

vmxnet3: Tue Oct 13 00:15:51 2009 -0700
vmw_pvscsi: Tue Oct 13 14:51:05 2009 -0700
vmwgfx: Thu Dec 10 00:19:58 2009 +0000
vmw_balloon: Fri Apr 23 13:18:08 2010 -0400

Thanks

- Bhavesh

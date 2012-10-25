Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965713Ab2JYVDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 17:03:25 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52204 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919Ab2JYVDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 17:03:24 -0400
Date: Thu, 25 Oct 2012 14:03:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Bhavesh Davda <bhavesh@vmware.com>
Cc: pv-drivers@vmware.com, vm-crosstalk@vmware.com,
        linux-kernel@vger.kernel.org, George Zhang <georgezhang@vmware.com>,
        virtualization@lists.linux-foundation.org,
        Andy King <acking@vmware.com>
Subject: Re: [Pv-drivers] [PATCH 04/10] VMCI: device driver implementaton.
Message-ID: <20121025210320.GA12352@kroah.com>
References: <20121025203148.GA28096@kroah.com>
 <280263520.16961242.1351197830586.JavaMail.root@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <280263520.16961242.1351197830586.JavaMail.root@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 01:43:50PM -0700, Bhavesh Davda wrote:
> Hi Greg,
> 
> > You can't just say "general GPL issues aside".  Honestly, given your
> > company's prior actions in regards to Linux kernel drivers and the
> > licenses of them, I don't trust them at all.  To help gain that trust
> > back, marking the exports in this manner will be a great improvement.
> >
> 
> You don't expect us to just let that comment slide :) Can you be more
> specific about which "prior actions" in regards to which kernel
> drivers, and when?

For many many years, you shipped closed source Linux kernel drivers for
your products.  Only recently has this changed.

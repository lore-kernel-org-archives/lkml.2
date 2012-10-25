Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278Ab2JYUQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:16:04 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:41526 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755951Ab2JYUQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:16:02 -0400
Date: Thu, 25 Oct 2012 13:16:00 -0700 (PDT)
From: Andy King <acking@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: pv-drivers@vmware.com, vm-crosstalk@vmware.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        George Zhang <georgezhang@vmware.com>
Message-ID: <574849395.2604157.1351196160882.JavaMail.root@vmware.com>
In-Reply-To: <20121025192851.GA26627@kroah.com>
Subject: Re: [Pv-drivers] [PATCH 04/10] VMCI: device driver implementaton.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC22 (Mac)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> > +EXPORT_SYMBOL(vmci_device_get);
> 
> EXPORT_SYMBOL_GPL() for this, and all other exports?

We'd prefer to leave them as vanilla exports.  While we're committed
to open-sourcing everything, including our non-upstreamed drivers,
we don't really have a strong opinion regarding consuming our exports
in closed-source (general GPL issues aside).

> And it seems that you have a bunch of "unused" parameters for this,
> and other public functions.  Please just remove them entirely.

Will do.

Also, regarding that particular public function, it seems to have slipped
through the cracks.  It's an artifact of the API being cross-platform
prior to upstreaming.  On Linux, it makes no sense whatsoever, so we'll
just yank it completely.

Thanks!
- Andy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab0DIUGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:06:17 -0400
Received: from sous-sol.org ([216.99.217.87]:45908 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755787Ab0DIUGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:06:15 -0400
Date: Fri, 9 Apr 2010 13:05:45 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Avi Kivity <avi@redhat.com>
Cc: Greg KH <gregkh@suse.de>, Tom Lyon <pugs@lyon-about.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for
 non-privileged processes
Message-ID: <20100409200545.GL3168@sequoia.sous-sol.org>
References: <201003311708.38961.pugs@lyon-about.com>
 <201004010906.47321.pugs@lyon-about.com>
 <4BB4C591.8000102@redhat.com>
 <201004011224.45336.pugs@lyon-about.com>
 <4BB59217.90102@redhat.com>
 <20100402170515.GA32579@suse.de>
 <4BBEFA3B.8070609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBEFA3B.8070609@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity (avi@redhat.com) wrote:
> On 04/02/2010 08:05 PM, Greg KH wrote:
> - access to all config space, but BARs must be translated so
> userspace cannot attack the host

Specifically, intermediated access to config space.  For example, need
to know about MSI/MSI-X updates in config space.

thanks,
-chris

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab2KZWh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 17:37:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:36943 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756271Ab2KZWh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 17:37:56 -0500
Date: Mon, 26 Nov 2012 14:37:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 00/12] VMCI for Linux upstreaming
Message-ID: <20121126223754.GA28681@kroah.com>
References: <20121121202625.13252.86346.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121202625.13252.86346.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 12:31:04PM -0800, George Zhang wrote:
> 
> * * *
> This series of VMCI linux upstreaming patches include latest udpate from
> VMware.
> 
> Summary of changes:
> 
> 	- Sparse clean.
> 	- Checkpatch clean with one exception, a "complex macro" in
> 	  which we can't add parentheses.
> 	- Remove all runtime assertions.
> 	- Fix device name, so that existing user clients work.
> 	- Fix VMCI handle lookup.

Given that you failed to answer the questions I asked the last time you
posted this series, and you did not make any of the changes I asked for,
I can't accept this (nor should you expect me to.)

And people wonder why reviewers get so grumpy...

My trees are now closed for the 3.8 merge window, so feel free to try
again after 3.8-rc1 is out, and you have answered, and addressed, the
questions and comments I made.

greg k-h

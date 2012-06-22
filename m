Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762572Ab2FVSvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:51:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39707 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab2FVSvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:51:45 -0400
Date: Fri, 22 Jun 2012 19:51:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        Alex Lyashkov <umka@cloudlinux.com>
Subject: Re: [PATCH] Taint kernel when lve module is loaded
Message-ID: <20120622185142.GA13225@srcf.ucam.org>
References: <1340387371-32292-1-git-send-email-mjg59@srcf.ucam.org>
 <20120622184359.GA25552@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622184359.GA25552@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 11:43:59AM -0700, Greg KH wrote:

> Do you have a pointer to this code anywhere?  Lying about the license to
> the kernel is a pretty blatent thing to do and I'd like to have some
> people follow up on that issue.

http://repo.cloudlinux.com/cloudlinux/5.8/updates-testing/x86_64/RPMS/kmod-lve-2.6.18-408.el5.lve1.1.64.2-1.1-10.7.3.el5.x86_64.rpm 
- there's no corresponding SRPM in 
http://repo.cloudlinux.com/cloudlinux/5.8/updates-testing/SRPMS/ and 
upstream apparently refuse to provide source. Alex Lyashkov (Cc:ed) is 
listed as module author in the metadata.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

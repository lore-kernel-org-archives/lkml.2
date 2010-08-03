Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab0HCRrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:47:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:44264 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254Ab0HCRru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:47:50 -0400
Date: Tue, 3 Aug 2010 10:44:06 -0700
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 3/6] staging: hv: Fixed the value of the 64bit-hole
 inside ring buffer
Message-ID: <20100803174405.GF1455@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56223FD1D45@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56223FD1D45@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 05:31:57PM +0000, Hank Janssen wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Fixed the value of the 64bit-hole inside ring buffer, this caused a problem on Hyper-V when running checked Windows builds.

What was the problem, and why would this fix it?  Was it a bug in this
code, by virtue that the code was incorrect in the client and the
checked builds properly warned of this, or something else?

thanks,

greg k-h

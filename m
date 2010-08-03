Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab0HCRrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:47:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254Ab0HCRrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:47:33 -0400
Date: Tue, 3 Aug 2010 10:37:32 -0700
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/6] staging: hv: Fixed bounce kmap problem by using
 correct index
Message-ID: <20100803173732.GA1455@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56223FD0D21@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56223FD0D21@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 05:31:51PM +0000, Hank Janssen wrote:
> From: Hank Janssen <hjanssen@microsoft.com> 
> 
> Fixed bounce offset kmap problem by using correct index

Is this a bugfix that needs to go to previous kernel releases?  If so,
which ones?  What is the symptom of the problem here?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab0HCRrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:47:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254Ab0HCRrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:47:43 -0400
Date: Tue, 3 Aug 2010 10:40:24 -0700
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 5/6] staging: hv: Increased storvsc ringbuffer and
 max_io_requests
Message-ID: <20100803174024.GD1455@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56223FD1D36@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56223FD1D36@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 05:31:55PM +0000, Hank Janssen wrote:
> From: Hank Janssen <hjanssen@microsoft.com>
> 
> Increased storvsc ringbuffer and max_io_requests. This now more closely mimics 
> the numbers on Hyper-V. And will allow more IO requests to take place for the SCSI driver.
> 
> Signed-off-by:Hank Janssen <hjanssen@microsoft.com>
> Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com> 

Again with the trailing spaces :(

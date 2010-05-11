Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab0EKLZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 07:25:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43968 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab0EKLZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 07:25:34 -0400
Date: Tue, 11 May 2010 13:25:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
       linux-acpi@vger.kernel.org
Subject: Re: ACPI, APEI support
Message-ID: <20100511112526.GA23942@basil.fritz.box>
References: <1272350481-27951-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272350481-27951-1-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 02:41:09PM +0800, Huang Ying wrote:
> 
> This patchset adds the APEI (ACPI Platform Error Interface) support to
> Linux kernel.
> 
> 01-06 include the basic APEI HEST parsing and EINJ support. They have
> been posted to mailing list before and get some reviews and
> ACKs. Changes since the last post are as follow.
> 
> - Make APEI infrastructure and HEST parsing configurable built-in
>   instead of modules to solve some dependency issues.
> 
> - Some minor fixes, such as printk
> 
> 07-10 are newly added to support GHES (Generic Hardware Error Source)
> corrected memory error. On some machines, Machine Check can not report
> physical address for some corrected memory errors, but GHES can do
> that. So this simplified GHES is implemented and posted firstly.

I read all the code again and it looks all good to go for .35 to me.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

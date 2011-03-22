Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab1CVDtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 23:49:41 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:64155 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab1CVDtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 23:49:39 -0400
X-Loopcount0: from 143.166.82.43
Date: Mon, 21 Mar 2011 22:49:37 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: gregkh@suse.de, Dave Jiang <dave.jiang@intel.com>,
        linux-scsi@vger.kernel.org, jacek.danecki@intel.com,
        ed.ciechanowski@intel.com, linux-kernel@vger.kernel.org,
        dmilburn@redhat.com, edmund.nadolski@intel.com,
        Mike Waychison <mikew@google.com>
Subject: Re: [PATCH] firmware/efi: export a routine to retrieve efi-variables by GUID
Message-ID: <20110322034937.GA20235@auslistsprd01.us.dell.com>
References: <20110318221606.26841.92271.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318221606.26841.92271.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 03:16:22PM -0700, Dan Williams wrote:
> From: Dave Jiang <dave.jiang@intel.com>
> 
> The efivars module already scans all available variables, normalizes the
> variable names, and stores them in a list.  Rather than duplicate this
> to efi runtime services interface let drivers query variable data by
> GUID.

Mike Waychison made a lot of good edits to the driver which are staged
for .39 in gregkh's tree.  Some of those changes will conflict with
your patch here, specifically the definition of struct efi_variable
moved similar to what you have done here.

You'll want to rebase your changes accordingly.

Thanks,
Matt

-- 
Matt Domsch
Technology Strategist
Dell | Office of the CTO

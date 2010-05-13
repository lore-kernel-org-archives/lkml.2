Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab0EMAZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 20:25:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:20643 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab0EMAZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 20:25:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,218,1272870000"; 
   d="scan'208";a="621215222"
Subject: Re: [PATCH 1/2] Add x64 support to debugfs
From: Huang Ying <ying.huang@intel.com>
To: Greg KH <greg@kroah.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>
In-Reply-To: <20100512214737.GA27785@kroah.com>
References: <1273653641-4519-1-git-send-email-ying.huang@intel.com>
	 <1273653641-4519-2-git-send-email-ying.huang@intel.com>
	 <20100512214737.GA27785@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 08:25:27 +0800
Message-ID: <1273710327.3564.61.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 05:47 +0800, Greg KH wrote:
> On Wed, May 12, 2010 at 04:40:40PM +0800, Huang Ying wrote:
> > Add debugfs_create_x64. This is needed by ACPI APEI EINJ parameters support.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > CC: Greg KH <greg@kroah.com>
> 
> Do you want me to take this through my tree?  Or should it go through
> the acpi one as you depend on it?
> 
> If so, that's fine with me, feel free to add:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> to the patch then.

Thank you very much for you kindness. Cross tree merging is pain, so I
want to go through the ACPI tree to make it easier.

Thanks,
Huang Ying



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab0EIVJB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 17:09:01 -0400
Received: from mga06.intel.com ([134.134.136.21]:11449 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751397Ab0EIVJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 17:09:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,358,1270450800"; 
   d="scan'208";a="516399123"
Date: Sun, 9 May 2010 23:09:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Todd Fischer <todd.fischer@ridgerun.com>, linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 4/4]-V3 Add MFD driver for TPS6507x family of
 multi-function chips and move TPS6507x regulator driver from being
 stand-alone to using the MFD driver.
Message-ID: <20100509210940.GA3269@sortiz.org>
References: <1270520639-20516-1-git-send-email-todd.fischer@ridgerun.com>
 <1270520639-20516-2-git-send-email-todd.fischer@ridgerun.com>
 <1270520639-20516-3-git-send-email-todd.fischer@ridgerun.com>
 <1270520639-20516-4-git-send-email-todd.fischer@ridgerun.com>
 <1270520639-20516-5-git-send-email-todd.fischer@ridgerun.com>
 <87633kacmq.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87633kacmq.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Wed, Apr 21, 2010 at 11:23:09AM -0700, Kevin Hilman wrote:
> Todd Fischer <todd.fischer@ridgerun.com> writes:
> 
> > Add MFD driver for TPS6507x family of multi-function chips.  Move TPS6507x 
> > regulator driver from being stand-alone driver to using the MFD TPS6507x driver.
> >
> > Signed-off-by: Todd Fischer <todd.fischer@ridgerun.com>
> 
> [...]
> 
> Not sure whose tree this is queued in currently, but testing with
> current davinci git, I had a compile problem...
This is fixed in the MFD tree.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab0LTKdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 05:33:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:33036 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab0LTKdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 05:33:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,201,1291622400"; 
   d="scan'208";a="638261082"
Date: Mon, 20 Dec 2010 11:33:37 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: build failure after merge of the final tree (mfd
 tree related)
Message-ID: <20101220103336.GC11095@sortiz-mobl>
References: <20101220192121.47767525.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220192121.47767525.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Dec 20, 2010 at 07:21:21PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
Ok, I removed Mark's commit, the MFD tree should build fine now.
I'm keeping this one for whenever we'll have a proper pwm framework.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab0DBNej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 09:34:39 -0400
Received: from mga10.intel.com ([192.55.52.92]:19893 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751619Ab0DBNed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 09:34:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,353,1267430400"; 
   d="scan'208";a="554468287"
Date: Fri, 2 Apr 2010 15:35:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Todd Fischer <todd.fischer@ridgerun.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 0/5] TPS6507x MFD driver
Message-ID: <20100402133508.GG8010@sortiz.org>
References: <1269634292-29686-1-git-send-email-todd.fischer@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269634292-29686-1-git-send-email-todd.fischer@ridgerun.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Todd,

On Fri, Mar 26, 2010 at 02:11:27PM -0600, Todd Fischer wrote:
> 
> The TPS6507x family of Texas Instruments power management ICs (pmic) 
> are multi-function chips that include voltage regulation and touch 
> screen controller capabilities.  This patch set adds a TPS6507x 
> multi-function device driver and change the TPS6507x regulator driver 
> to use the TPS6507x MFD driver instead of interacting with the chip 
> directly.  The changes are needed before a touch screen driver can be 
> added.
> 
> The patch set applies cleanly to the MFD repository: 
> git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git  
> If the MFD and voltage regulator maintainer would prefer I post 
> patches for a different repository, please let me know.
Mark's review is fairly complete. Please address his concerns, and I'll merge
this patchset.

Cheers,
Samuel.


> The TPS6507x touch screen input driver will be posted to 
> linux-input@vger.kernel.org list.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

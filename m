Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1B1Rtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 12:49:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:58901 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab1B1Rtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 12:49:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,241,1297065600"; 
   d="scan'208";a="395177320"
Subject: Re: [PATCH 04/10] PTI Makefile and Kconfig additions.
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
In-Reply-To: <201102281031.42402.arnd@arndb.de>
References: <james_p_freyensee@linux.intel.com>
	 <1298570824-26085-5-git-send-email-james_p_freyensee@linux.intel.com>
	 <201102281031.42402.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 28 Feb 2011 09:49:33 -0800
Message-ID: <1298915373.3156.34.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 10:31 +0100, Arnd Bergmann wrote:
> On Thursday 24 February 2011, james_p_freyensee@linux.intel.com wrote:
> > 
> > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > 
> > This allows the Intel implementation of the PTI standard to be
> > compiled and configured in Kconfig.
> > 
> > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> This belongs together with the pti.c file, just merge the patches
> into one.
> 
> The Kconfig description is a nice text, how about copying it to the
> changeset so that reviewers know what the driver is about?
> 
> 	Arnd

I thought patch 02/10, 'Kernel documentation', would had been first and
met this need?  


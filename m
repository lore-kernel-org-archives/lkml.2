Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab0ETS0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:26:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:7241 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab0ETS0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:26:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,272,1272870000"; 
   d="scan'208";a="800348706"
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
From: reinette chatre <reinette.chatre@intel.com>
To: Nils Radtke <lkml@Think-Future.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100520123144.GA8153@localhost>
References: <20100513150504.GB7535@localhost>
	 <1274138381.2091.4864.camel@rchatre-DESK> <20100520123144.GA8153@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 May 2010 11:26:07 -0700
Message-ID: <1274379967.2091.9257.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 05:31 -0700, Nils Radtke wrote:
> Hi Reinette,
> 
>   Did the fix like the patch below, applied on top of yours. Builds well, 
>   not tested yet.
> 
>   Do you ACK this patch?

I do. I'm very sorry about the problem with the one I provided.

Reinette



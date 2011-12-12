Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1LLRDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:03:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:38188 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab1LLRDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:03:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="84834632"
Date: Mon, 12 Dec 2011 18:08:46 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        gregkh@suse.de, akpm@linux-foundation.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] misc: add driver support for MAX8997 MUIC
Message-ID: <20111212170846.GO13952@sortiz-mobl>
References: <1322125938-6944-2-git-send-email-dg77.kim@samsung.com>
 <1322125938-6944-3-git-send-email-dg77.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322125938-6944-3-git-send-email-dg77.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

On Thu, Nov 24, 2011 at 06:12:18PM +0900, Donggeun Kim wrote:
> The MUIC function in MAX8997 device can be used as
> a USB port detector and switch.
> This patch supports the MUIC feature of MAX8997.

I'm queueing this one to my for-next branch as it depends on your previous MFD
patch.
I'm also cc'ing Arnd in case he has some objections.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

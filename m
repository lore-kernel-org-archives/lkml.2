Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab2EIOA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:00:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:21228 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab2EIOA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:00:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="138646757"
Date: Wed, 9 May 2012 16:10:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: da9052: fix of_match_node() arguments
Message-ID: <20120509141036.GF1794@sortiz-mobl>
References: <1336258968-6423-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336258968-6423-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On Sat, May 05, 2012 at 04:02:48PM -0700, Olof Johansson wrote:
> The driver calls of_match_node() with the arguments swapped.
Thanks, patch applied to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

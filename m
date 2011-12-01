Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab1LAP4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:56:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:6105 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab1LAP4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:56:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,278,1320652800"; 
   d="scan'208";a="91110260"
Date: Thu, 1 Dec 2011 17:01:14 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] nfc: Remove function tracer like entry messages
Message-ID: <20111201160114.GG22609@sortiz-mobl>
References: <cover.1322595343.git.joe@perches.com>
 <038f52f06c7c878e0e2b4965f3a64ac72cf5196d.1322595343.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <038f52f06c7c878e0e2b4965f3a64ac72cf5196d.1322595343.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, Nov 29, 2011 at 11:37:35AM -0800, Joe Perches wrote:
> Logging messages that mimic function tracer enter/exit
> aren't necessary.  Just remove them.
>
> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

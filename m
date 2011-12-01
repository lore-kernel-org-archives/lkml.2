Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1LATJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:09:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:9351 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab1LATJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:09:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,279,1320652800"; 
   d="scan'208";a="97564846"
Date: Thu, 1 Dec 2011 20:14:21 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] NFC: pn533: Staticise pn533_data_exchange()
Message-ID: <20111201191421.GK22609@sortiz-mobl>
References: <1322648286.6774.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322648286.6774.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Nov 30, 2011 at 06:18:06PM +0800, Axel Lin wrote:
> It is not used outside this driver so no need to make the symbol global.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

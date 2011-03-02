Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab1CBKeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:34:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:26431 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab1CBKeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:34:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,252,1297065600"; 
   d="scan'208";a="608167186"
Date: Wed, 2 Mar 2011 11:33:54 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jz4740: silence warnings related to mfd_get_cell
 changes
Message-ID: <20110302103353.GD16181@sortiz-mobl>
References: <20110301133548.6acb5170@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301133548.6acb5170@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Tue, Mar 01, 2011 at 01:35:48PM -0800, Andres Salomon wrote:
> 
> mfd_get_cell returns a const, so change the jz4740 clients to store
> a const mfd cell.  This silences type mismatch warnings.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

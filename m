Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1DZPxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:53:01 -0400
Received: from imr4.ericy.com ([198.24.6.8]:58527 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1DZPw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:52:59 -0400
Date: Tue, 26 Apr 2011 08:52:39 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Len Brown <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Rene Herman <rene.herman@gmail.com>
Subject: Re: [PATCH v2 1/3] thermal: Hide CONFIG_THERMAL_HWMON
Message-ID: <20110426155239.GC18176@ericsson.com>
References: <20110426165600.1d9ac91b@endymion.delvare>
 <20110426170208.504b04e9@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110426170208.504b04e9@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 11:02:08AM -0400, Jean Delvare wrote:
> It's about time to revert 16d752397301b95abaa95cbaf9e785d221872311.
> Anybody running a kernel >= 2.6.40 would also be running a recent
> enough version of lm-sensors.
> 
> Actually having CONFIG_THERMAL_HWMON is pretty convenient so instead
> of dopping it, we keep it but hide it.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Rene Herman <rene.herman@gmail.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Guenter Roeck <guenter.roeck@ericsson.com>

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
